package com.enterprise.procurement.service;

import com.enterprise.procurement.entity.POLineItem;
import com.enterprise.procurement.entity.PurchaseOrder;
import com.enterprise.procurement.entity.Requisition;
import com.enterprise.procurement.entity.RequisitionStatus;
import com.enterprise.procurement.repository.PurchaseOrderRepository;
import com.enterprise.procurement.repository.RequisitionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PurchaseOrderService extends BaseService<PurchaseOrder, Long> {

    private final RequisitionRepository requisitionRepository;
    private final AuditLogService auditLogService;
    private final NotificationService notificationService;

    public PurchaseOrderService(PurchaseOrderRepository repository, RequisitionRepository requisitionRepository,
                                AuditLogService auditLogService, NotificationService notificationService) {
        super(repository);
        this.requisitionRepository = requisitionRepository;
        this.auditLogService = auditLogService;
        this.notificationService = notificationService;
    }

    @Override
    public List<PurchaseOrder> findAll() {
        return ((PurchaseOrderRepository) repository).findAllByOrderByCreatedAtDesc();
    }

    @Transactional
    public PurchaseOrder createFromRequisition(Requisition requisition) {
        if (requisition.getSupplier() == null) {
            throw new IllegalArgumentException("Cannot generate Purchase Order: Requisition is missing a supplier.");
        }

        // Idempotency: Prevent duplicate PO for the same requisition
        java.util.Optional<PurchaseOrder> existingPo = ((PurchaseOrderRepository) repository)
                .findByRequisition_RequisitionId(requisition.getRequisitionId());
        if (existingPo.isPresent()) {
            return existingPo.get();
        }

        String poNumber = "PO-" + requisition.getRequisitionNumber().replace("REQ-", "");
        
        java.math.BigDecimal reqAmt = requisition.getTotalAmount() != null ? requisition.getTotalAmount() : java.math.BigDecimal.ZERO;
        java.math.BigDecimal taxAmt = reqAmt.multiply(java.math.BigDecimal.valueOf(0.10)); // 10% standard tax
        
        PurchaseOrder po = PurchaseOrder.builder()
                .poNumber(poNumber)
                .requisition(requisition)
                .supplier(requisition.getSupplier())
                .totalAmount(reqAmt.add(taxAmt))
                .taxAmount(taxAmt)
                .deliveryDate(LocalDate.now().plusDays(14)) // default ETA 14 days
                .createdDate(LocalDate.now())
                .stage("CREATED")
                .status("PENDING") // Using PENDING for supplier acceptance
                .build();

        if (requisition.getLineItems() != null && !requisition.getLineItems().isEmpty()) {
            List<POLineItem> poLineItems = requisition.getLineItems().stream()
                    .map(reqItem -> POLineItem.builder()
                            .purchaseOrder(po)
                            .description(reqItem.getDescription())
                            .orderedQty(reqItem.getQuantity())
                            .receivedQty(0)
                            .unitPrice(reqItem.getUnitPrice())
                            .build())
                    .collect(Collectors.toList());
            po.setLineItems(poLineItems);
        }

        PurchaseOrder savedPo = repository.save(po);

        requisition.setStatus(RequisitionStatus.ORDER_CREATED);
        requisitionRepository.save(requisition);

        // Insert Audit Log
        com.enterprise.procurement.entity.AuditLog audit = com.enterprise.procurement.entity.AuditLog.builder()
                .user(requisition.getCreatedBy())
                .module("PurchaseOrder")
                .action("CREATE")
                .entityName("PurchaseOrder")
                .entityId(savedPo.getPoId())
                .remarks("Automatically generated PO " + savedPo.getPoNumber() + " from Requisition " + requisition.getRequisitionNumber())
                .build();
        auditLogService.save(audit);

        // Insert Notification for Requester
        notificationService.createNotification(
                requisition.getCreatedBy().getUsername(),
                "Purchase Order Generated",
                "Purchase Order " + savedPo.getPoNumber() + " has been generated for your requisition.",
                "PurchaseOrder",
                savedPo.getPoId()
        );

        return savedPo;
    }

    public PurchaseOrder update(Long id, PurchaseOrder purchaseOrder) {
        PurchaseOrder existing = findById(id);
        existing.setPoNumber(purchaseOrder.getPoNumber());
        existing.setRequisition(purchaseOrder.getRequisition());
        existing.setSupplier(purchaseOrder.getSupplier());
        existing.setCreatedDate(purchaseOrder.getCreatedDate());
        existing.setStage(purchaseOrder.getStage());
        existing.setStatus(purchaseOrder.getStatus());
        return save(existing);
    }
}
