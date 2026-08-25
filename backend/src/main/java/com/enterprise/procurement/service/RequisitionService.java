package com.enterprise.procurement.service;

import com.enterprise.procurement.dto.RequisitionActionRequest;
import com.enterprise.procurement.dto.RequisitionCreateRequest;
import com.enterprise.procurement.entity.*;
import com.enterprise.procurement.event.RequisitionApprovedEvent;
import com.enterprise.procurement.exception.BadRequestException;
import com.enterprise.procurement.exception.ResourceNotFoundException;
import com.enterprise.procurement.repository.*;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.stream.Collectors;

@Service
public class RequisitionService extends BaseService<Requisition, Long> {

    private final UserRepository userRepository;
    private final DepartmentRepository departmentRepository;
    private final CategoryRepository categoryRepository;
    private final SupplierRepository supplierRepository;
    private final ApprovalRuleRepository approvalRuleRepository;
    private final ApprovalRuleApproverRepository approvalRuleApproverRepository;
    private final RequisitionHistoryRepository requisitionHistoryRepository;
    private final AuditLogService auditLogService;
    private final NotificationService notificationService;
    private final ApplicationEventPublisher eventPublisher;
    private final RoleRepository roleRepository;

    public RequisitionService(RequisitionRepository repository,
                              UserRepository userRepository,
                              DepartmentRepository departmentRepository,
                              CategoryRepository categoryRepository,
                              SupplierRepository supplierRepository,
                              ApprovalRuleRepository approvalRuleRepository,
                              ApprovalRuleApproverRepository approvalRuleApproverRepository,
                              RequisitionHistoryRepository requisitionHistoryRepository,
                              AuditLogService auditLogService,
                              NotificationService notificationService,
                              ApplicationEventPublisher eventPublisher,
                              RoleRepository roleRepository) {
        super(repository);
        this.userRepository = userRepository;
        this.departmentRepository = departmentRepository;
        this.categoryRepository = categoryRepository;
        this.supplierRepository = supplierRepository;
        this.approvalRuleRepository = approvalRuleRepository;
        this.approvalRuleApproverRepository = approvalRuleApproverRepository;
        this.requisitionHistoryRepository = requisitionHistoryRepository;
        this.auditLogService = auditLogService;
        this.notificationService = notificationService;
        this.eventPublisher = eventPublisher;
        this.roleRepository = roleRepository;
    }

    // ---------------------------------------------------------------
    // TIMELINE
    // ---------------------------------------------------------------
    public List<com.enterprise.procurement.dto.TimelineEvent> getRequisitionTimeline(Long id) {
        Requisition req = findById(id);
        
        List<RequisitionHistory> history = requisitionHistoryRepository.findByRequisition(req);
        List<AuditLog> audits = auditLogService.findAll().stream() // Ideally we would have a repository method for this
                .filter(a -> ("Requisition".equals(a.getEntityName()) && id.equals(a.getEntityId())) ||
                             (a.getRemarks() != null && (a.getRemarks().contains("REQ-" + id) || a.getRemarks().contains("Requisition " + id))))
                .collect(Collectors.toList());

        List<com.enterprise.procurement.dto.TimelineEvent> events = new java.util.ArrayList<>();
        
        for (RequisitionHistory h : history) {
            String actor = h.getActionBy() != null ? (h.getActionBy().getFullName() != null ? h.getActionBy().getFullName() : h.getActionBy().getUsername()) : "System";
            events.add(com.enterprise.procurement.dto.TimelineEvent.builder()
                    .step(h.getStep())
                    .actionBy(actor)
                    .remarks(h.getRemarks())
                    .actionDate(h.getActionDate())
                    .build());
        }
        
        for (AuditLog a : audits) {
            events.add(com.enterprise.procurement.dto.TimelineEvent.builder()
                    .step(a.getModule() + " " + a.getAction())
                    .actionBy(a.getUser() != null ? a.getUser().getUsername() : "System")
                    .remarks(a.getRemarks())
                    .actionDate(a.getActionTime())
                    .build());
        }

        // Merge and sort
        events.sort(java.util.Comparator.comparing(com.enterprise.procurement.dto.TimelineEvent::getActionDate));
        
        // Deduplicate by remarks if they overlap
        java.util.Map<String, com.enterprise.procurement.dto.TimelineEvent> unique = new java.util.LinkedHashMap<>();
        for(com.enterprise.procurement.dto.TimelineEvent e : events) {
            unique.put(e.getRemarks(), e);
        }

        return new java.util.ArrayList<>(unique.values());
    }

    // ---------------------------------------------------------------
    // CREATE
    // ---------------------------------------------------------------

    @Transactional
    public Requisition create(RequisitionCreateRequest request, String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with username: " + username));

        Department department = departmentRepository.findById(user.getDepartment().getDepartmentId())
                .orElseThrow(() -> new ResourceNotFoundException("Department not found for current user"));

        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id " + request.getCategoryId()));

        Supplier supplier = null;
        if (request.getSupplierId() != null) {
            supplier = supplierRepository.findById(request.getSupplierId())
                    .orElseThrow(() -> new ResourceNotFoundException("Supplier not found with id " + request.getSupplierId()));
        }

        BigDecimal totalAmount = calculateTotalAmount(request.getItems());

        Optional<ApprovalRule> matchingRule = approvalRuleRepository
                .findMatchingRule(department.getDepartmentId(), category.getCategoryId(), totalAmount);

        Requisition requisition = new Requisition();
        requisition.setRequisitionNumber(generateRequisitionNumber());
        requisition.setCreatedBy(user);
        requisition.setDepartment(department);
        requisition.setSupplier(supplier);
        requisition.setCategory(category);
        requisition.setTitle(request.getTitle());
        requisition.setJustification(request.getJustification());
        requisition.setNeededBy(request.getNeededBy());
        requisition.setTotalAmount(totalAmount);
        requisition.setStatus(RequisitionStatus.PENDING_APPROVAL);
        requisition.setPriority(request.getPriority() != null ? request.getPriority() : "MEDIUM");

        List<RequisitionLineItem> lineItems = request.getItems().stream()
                .map(item -> RequisitionLineItem.builder()
                        .requisition(requisition)
                        .description(item.getDescription())
                        .quantity(item.getQuantity())
                        .unitPrice(item.getUnitPrice())
                        .build())
                .collect(Collectors.toList());
        requisition.setLineItems(lineItems);

        Requisition savedRequisition = save(requisition);
        createHistory(savedRequisition, user, "Submitted", "Request submitted for approval");

        // Save AuditLog
        AuditLog audit = AuditLog.builder()
                .user(user)
                .module("Requisition")
                .action("CREATE")
                .entityName("Requisition")
                .entityId(savedRequisition.getRequisitionId())
                .remarks("Created Requisition " + savedRequisition.getRequisitionNumber())
                .build();
        auditLogService.save(audit);

        notificationService.createNotification(username, "Requisition Submitted", "Your Requisition " + savedRequisition.getRequisitionNumber() + " was submitted.", "Requisition", savedRequisition.getRequisitionId());

        return savedRequisition;
    }

    // ---------------------------------------------------------------
    // APPROVE / REJECT  — now a real ordered multi-step chain
    // ---------------------------------------------------------------

    private List<Long> getApprovalChainRoleIds(Requisition requisition) {
        Optional<ApprovalRule> ruleOpt = approvalRuleRepository.findMatchingRule(
                requisition.getDepartment().getDepartmentId(),
                requisition.getCategory().getCategoryId(),
                requisition.getTotalAmount());
        
        if (ruleOpt.isPresent()) {
            List<ApprovalRuleApprover> chain = approvalRuleApproverRepository
                    .findByRule_RuleIdOrderBySequenceNoAsc(ruleOpt.get().getRuleId());
            if (!chain.isEmpty()) {
                return chain.stream()
                        .map(approver -> approver.getRole().getRoleId())
                        .collect(Collectors.toList());
            }
        }
        
        // Fallback enterprise logic based on amount
        BigDecimal amt = requisition.getTotalAmount();
        Role managerRole = roleRepository.findByRoleName("Manager").orElseThrow();
        Role financeRole = roleRepository.findByRoleName("Finance").orElseThrow();
        Role adminRole = roleRepository.findByRoleName("Admin").orElseThrow();

        if (amt.compareTo(new BigDecimal("50000")) <= 0) {
            return List.of(managerRole.getRoleId());
        } else if (amt.compareTo(new BigDecimal("500000")) <= 0) {
            return List.of(managerRole.getRoleId(), financeRole.getRoleId());
        } else {
            return List.of(managerRole.getRoleId(), financeRole.getRoleId(), adminRole.getRoleId());
        }
    }

    @Transactional
    public Requisition actOnRequisition(Long id, RequisitionActionRequest request, String username) {
        Requisition requisition = findById(id);
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with username: " + username));

        if (!RequisitionStatus.PENDING_APPROVAL.equalsIgnoreCase(requisition.getStatus())) {
            throw new BadRequestException("Only requisitions pending approval can be acted upon");
        }

        List<Long> chainRoleIds = getApprovalChainRoleIds(requisition);

        // Figure out which step we're on by counting completed "Approved" steps so far in current cycle
        long completedSteps = requisitionHistoryRepository
                .countCurrentCycleApprovals(requisition.getRequisitionId());

        if (completedSteps >= chainRoleIds.size()) {
            throw new BadRequestException("This requisition has already completed its approval chain");
        }

        Long requiredRoleId = chainRoleIds.get((int) completedSteps);

        // Confirm the logged-in user actually holds the role required for THIS step
        boolean isCorrectApprover = user.getUserRoles().stream()
                .anyMatch(userRole -> userRole.getRole().getRoleId().equals(requiredRoleId));

        if (!isCorrectApprover) {
            String requiredRoleName = "Role ID " + requiredRoleId;
            if (requiredRoleId == 3L) requiredRoleName = "Manager";
            else if (requiredRoleId == 4L) requiredRoleName = "Finance";
            
            throw new AccessDeniedException(
                    "This requisition is currently awaiting approval from role: "
                            + requiredRoleName + ". You are not authorized to act on it yet.");
        }

        String action = request.getAction().trim().toUpperCase();

        if ("APPROVE".equals(action) || "APPROVED".equals(action)) {
            createHistory(requisition, user, "Approved", request.getRemarks());

            boolean wasLastStep = (completedSteps + 1) == chainRoleIds.size();
            if (wasLastStep) {
                requisition.setStatus(RequisitionStatus.APPROVED);
                eventPublisher.publishEvent(new RequisitionApprovedEvent(this, requisition));
            }
            // If it wasn't the last step, status stays PENDING_APPROVAL —
            // the next approver in the chain now sees it in their pending list.

        } else if ("REJECT".equals(action) || "REJECTED".equals(action)) {
            requisition.setStatus(RequisitionStatus.REJECTED);
            createHistory(requisition, user, "Rejected", request.getRemarks());

        } else if ("RETURN".equals(action) || "RETURNED".equals(action)) {
            requisition.setStatus(RequisitionStatus.RETURNED);
            createHistory(requisition, user, "Returned", request.getRemarks());

        } else {
            throw new BadRequestException("Action must be APPROVE, REJECT, or RETURN");
        }

        Requisition savedRequisition = save(requisition);

        // Save AuditLog
        AuditLog audit = AuditLog.builder()
                .user(user)
                .module("Approval")
                .action(action)
                .entityName("Requisition")
                .entityId(savedRequisition.getRequisitionId())
                .remarks("Requisition " + action + " by " + user.getUsername() + (request.getRemarks() != null ? " — " + request.getRemarks() : ""))
                .build();
        auditLogService.save(audit);

        return savedRequisition;
    }

    @Transactional
    public Requisition updateSupplier(Long id, Long supplierId, String adminUsername) {
        Requisition requisition = findById(id);
        
        Supplier supplier = supplierRepository.findById(supplierId)
            .orElseThrow(() -> new ResourceNotFoundException("Supplier not found"));
            
        requisition.setSupplier(supplier);
        
        User admin = userRepository.findByUsername(adminUsername)
            .orElseThrow(() -> new ResourceNotFoundException("Admin user not found"));
        
        // Log Audit
        AuditLog audit = AuditLog.builder()
            .user(admin)
            .module("Requisition")
            .action("SUPPLIER_CORRECTED")
            .entityName("Requisition")
            .entityId(id)
            .remarks("Supplier assigned to repair legacy requisition before PO generation.")
            .build();
        auditLogService.save(audit);
        
        // Add to history so it appears in the approval timeline
        createHistory(requisition, admin, "Supplier Corrected", "Supplier missing in legacy requisition was assigned by Admin.");
        
        return repository.save(requisition);
    }

    public List<String> getApprovalChainNames(Long categoryId, BigDecimal amount, String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with username: " + username));

        Department department = departmentRepository.findById(user.getDepartment().getDepartmentId())
                .orElseThrow(() -> new ResourceNotFoundException("Department not found for current user"));

        Optional<ApprovalRule> matchingRule = approvalRuleRepository
                .findMatchingRule(department.getDepartmentId(), categoryId, amount);

        if (matchingRule.isPresent()) {
            List<ApprovalRuleApprover> chain = approvalRuleApproverRepository
                    .findByRule_RuleIdOrderBySequenceNoAsc(matchingRule.get().getRuleId());
            if (!chain.isEmpty()) {
                return chain.stream()
                        .map(approver -> approver.getRole().getRoleName())
                        .collect(Collectors.toList());
            }
        }
        
        // Fallback enterprise logic
        if (amount.compareTo(new BigDecimal("50000")) <= 0) {
            return List.of("Manager");
        } else if (amount.compareTo(new BigDecimal("500000")) <= 0) {
            return List.of("Manager", "Finance");
        } else {
            return List.of("Manager", "Finance", "Admin");
        }
    }

    // ---------------------------------------------------------------
    // QUERIES
    // ---------------------------------------------------------------

    public List<Requisition> findMyRequisitions(String username) {
        return ((RequisitionRepository) repository).findByCreatedBy_UsernameOrderByCreatedAtDesc(username);
    }

    public List<Requisition> findByStatus(String status) {
        return ((RequisitionRepository) repository).findByStatusOrderByCreatedAtDesc(status);
    }

    // "What's pending for ME to approve right now" — computes current step per
    // requisition, same logic as actOnRequisition, but read-only and filtered
    // to requisitions where it's currently this user's turn.
    public List<Requisition> findPendingForApprover(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with username: " + username));

        List<Requisition> pending = ((RequisitionRepository) repository)
                .findByStatusOrderByCreatedAtDesc(RequisitionStatus.PENDING_APPROVAL);

        List<Long> userRoleIds = user.getUserRoles().stream()
                .map(userRole -> userRole.getRole().getRoleId())
                .collect(Collectors.toList());

        return pending.stream()
                .filter(req -> isCurrentUsersTurn(req, userRoleIds))
                .collect(Collectors.toList());
    }

    @Override
    public List<Requisition> findAll() {
        return ((RequisitionRepository) repository).findAllByOrderByCreatedAtDesc();
    }

    public List<Requisition> findMyApprovals(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with username: " + username));
        
        boolean isAdmin = user.getUserRoles().stream()
                .anyMatch(ur -> "Admin".equals(ur.getRole().getRoleName()));
                
        if (isAdmin) {
            return findAll();
        }

        return requisitionHistoryRepository.findByActionBy_UsernameOrderByActionDateDesc(username).stream()
                .map(RequisitionHistory::getRequisition)
                .distinct()
                .collect(Collectors.toList());
    }

    private boolean isCurrentUsersTurn(Requisition requisition, List<Long> userRoleIds) {
        List<Long> chainRoleIds = getApprovalChainRoleIds(requisition);

        long completedSteps = requisitionHistoryRepository
                .countCurrentCycleApprovals(requisition.getRequisitionId());
        if (completedSteps >= chainRoleIds.size()) return false;

        Long requiredRoleId = chainRoleIds.get((int) completedSteps);
        return userRoleIds.contains(requiredRoleId);
    }

// ---------------------------------------------------------------
    // HELPERS (unchanged from your version)
    // ---------------------------------------------------------------

    private void createHistory(Requisition requisition, User actionBy, String step, String remarks) {
        RequisitionHistory history = RequisitionHistory.builder()
                .requisition(requisition)
                .actionBy(actionBy)
                .step(step)
                .remarks(remarks)
                .build();
        requisitionHistoryRepository.save(history);
    }

    private BigDecimal calculateTotalAmount(List<RequisitionCreateRequest.LineItemRequest> items) {
        return items.stream()
                .map(item -> item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private String generateRequisitionNumber() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        int suffix = new Random().nextInt(9000) + 1000;
        return "REQ-" + timestamp + "-" + suffix;
    }

    public Requisition update(Long id, Requisition requisition) {
        Requisition existing = findById(id);
        existing.setRequisitionNumber(requisition.getRequisitionNumber());
        existing.setCreatedBy(requisition.getCreatedBy());
        existing.setDepartment(requisition.getDepartment());
        existing.setSupplier(requisition.getSupplier());
        existing.setCategory(requisition.getCategory());
        existing.setTitle(requisition.getTitle());
        existing.setJustification(requisition.getJustification());
        existing.setNeededBy(requisition.getNeededBy());
        existing.setTotalAmount(requisition.getTotalAmount());
        existing.setStatus(requisition.getStatus());
        existing.setPriority(requisition.getPriority());
        return save(existing);
    }
}