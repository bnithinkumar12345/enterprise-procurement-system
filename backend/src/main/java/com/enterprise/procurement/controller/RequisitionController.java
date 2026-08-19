package com.enterprise.procurement.controller;

import com.enterprise.procurement.dto.RequisitionActionRequest;
import com.enterprise.procurement.dto.RequisitionApprovalRequest;
import com.enterprise.procurement.dto.RequisitionCreateRequest;
import com.enterprise.procurement.entity.Requisition;
import com.enterprise.procurement.service.RequisitionService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import org.springframework.security.access.prepost.PreAuthorize;
import java.util.List;
import com.enterprise.procurement.dto.TimelineEvent;
import com.enterprise.procurement.service.AuditLogService;

@RestController
@RequestMapping("/api/requisitions")
@CrossOrigin("*")
public class RequisitionController {

    private final RequisitionService service;

    public RequisitionController(RequisitionService service) {
        this.service = service;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('Admin', 'Finance')")
    public ResponseEntity<List<Requisition>> getAll(@RequestParam(required = false) String status) {
        if (status != null && !status.isBlank()) {
            return ResponseEntity.ok(service.findByStatus(status));
        }
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/my")
    public ResponseEntity<List<Requisition>> getMyRequests(Authentication authentication) {
        return ResponseEntity.ok(service.findMyRequisitions(authentication.getName()));
    }

    // SECURITY FIX: previously had no access control at all — any logged-in
    // user could view any requisition's full details just by guessing or
    // incrementing the ID, regardless of who created it or which department
    // it belongs to. Now: Admin/Finance/Manager can view anything; a
    // Requester can only view requisitions they created themselves.
    @GetMapping("/{id}")
    public ResponseEntity<Requisition> getById(@PathVariable Long id, Authentication authentication) {
        Requisition requisition = service.findById(id);

        boolean canViewAll = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_Admin")
                        || a.getAuthority().equals("ROLE_Finance")
                        || a.getAuthority().equals("ROLE_Manager"));

        boolean ownsIt = requisition.getCreatedBy() != null
                && authentication.getName().equals(requisition.getCreatedBy().getUsername());

        if (!canViewAll && !ownsIt) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        return ResponseEntity.ok(requisition);
    }

    @GetMapping("/pending")
    @PreAuthorize("hasAnyRole('Admin', 'Manager', 'Finance')")
    public ResponseEntity<List<Requisition>> getPendingForMe(Authentication authentication) {
        return ResponseEntity.ok(service.findPendingForApprover(authentication.getName()));
    }

    @PostMapping
    public ResponseEntity<Requisition> create(@Valid @RequestBody RequisitionCreateRequest request,
                                              Authentication authentication) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(service.create(request, authentication.getName()));
    }

    // SECURITY FIX: same issue as getById() above — previously anyone could
    // pull the full approval timeline of any requisition by ID alone. Same
    // ownership check applied here.
    @GetMapping("/{id}/timeline")
    public ResponseEntity<List<TimelineEvent>> getTimeline(@PathVariable Long id, Authentication authentication) {
        Requisition requisition = service.findById(id);

        boolean canViewAll = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_Admin")
                        || a.getAuthority().equals("ROLE_Finance")
                        || a.getAuthority().equals("ROLE_Manager"));

        boolean ownsIt = requisition.getCreatedBy() != null
                && authentication.getName().equals(requisition.getCreatedBy().getUsername());

        if (!canViewAll && !ownsIt) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        return ResponseEntity.ok(service.getRequisitionTimeline(id));
    }

    @GetMapping("/approvals/history")
    @PreAuthorize("hasAnyRole('Admin', 'Manager', 'Finance')")
    public ResponseEntity<List<Requisition>> getMyApprovalsHistory(Authentication authentication) {
        return ResponseEntity.ok(service.findMyApprovals(authentication.getName()));
    }

    @GetMapping("/preview-approval")
    public ResponseEntity<List<String>> previewApprovalChain(
            @RequestParam Long categoryId,
            @RequestParam java.math.BigDecimal amount,
            Authentication authentication) {
        return ResponseEntity.ok(service.getApprovalChainNames(categoryId, amount, authentication.getName()));
    }

    @PostMapping("/{id}/actions")
    @PreAuthorize("hasAnyRole('Admin', 'Manager', 'Finance')")
    public ResponseEntity<Requisition> actOnRequisition(@PathVariable Long id,
                                                        @Valid @RequestBody RequisitionActionRequest request,
                                                        Authentication authentication) {
        return ResponseEntity.ok(service.actOnRequisition(id, request, authentication.getName()));
    }

    @RequestMapping(value = "/{id}/approve", method = {RequestMethod.POST, RequestMethod.PUT})
    @PreAuthorize("hasAnyRole('Admin', 'Manager', 'Finance')")
    public ResponseEntity<Requisition> approve(@PathVariable Long id,
                                               @RequestBody(required = false) RequisitionApprovalRequest request,
                                               Authentication authentication) {
        RequisitionActionRequest actionReq = new RequisitionActionRequest();
        actionReq.setAction("APPROVE");
        if (request != null) {
            actionReq.setRemarks(request.getRemarks());
        }
        return ResponseEntity.ok(service.actOnRequisition(id, actionReq, authentication.getName()));
    }

    @RequestMapping(value = "/{id}/reject", method = {RequestMethod.POST, RequestMethod.PUT})
    @PreAuthorize("hasAnyRole('Admin', 'Manager', 'Finance')")
    public ResponseEntity<Requisition> reject(@PathVariable Long id,
                                              @RequestBody(required = false) RequisitionApprovalRequest request,
                                              Authentication authentication) {
        RequisitionActionRequest actionReq = new RequisitionActionRequest();
        actionReq.setAction("REJECT");
        if (request != null) {
            actionReq.setRemarks(request.getRemarks());
        }
        return ResponseEntity.ok(service.actOnRequisition(id, actionReq, authentication.getName()));
    }

    @PatchMapping("/{id}/supplier")
    @PreAuthorize("hasRole('Admin')")
    public ResponseEntity<Requisition> updateSupplier(@PathVariable Long id,
                                                      @RequestBody java.util.Map<String, Long> payload,
                                                      Authentication authentication) {
        Long supplierId = payload.get("supplierId");
        if (supplierId == null) {
            throw new IllegalArgumentException("Supplier ID is required");
        }
        return ResponseEntity.ok(service.updateSupplier(id, supplierId, authentication.getName()));
    }

    @PostMapping("/{id}/supplier/verify")
    @PreAuthorize("hasRole('Admin')")
    public ResponseEntity<Requisition> verifySupplier(@PathVariable Long id,
                                                      @RequestBody java.util.Map<String, Object> payload,
                                                      Authentication authentication) {
        boolean approved = Boolean.TRUE.equals(payload.get("approved"));
        String remarks = (String) payload.get("remarks");
        return ResponseEntity.ok(service.verifySupplier(id, approved, remarks, authentication.getName()));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('Admin')")
    public ResponseEntity<Requisition> update(@PathVariable Long id,
                                              @Valid @RequestBody Requisition requisition) {
        return ResponseEntity.ok(service.update(id, requisition));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('Admin')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}