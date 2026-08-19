package com.enterprise.procurement.repository;

import com.enterprise.procurement.entity.PurchaseOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface PurchaseOrderRepository extends JpaRepository<PurchaseOrder, Long> {
    List<PurchaseOrder> findAllByOrderByCreatedAtDesc();
    Optional<PurchaseOrder> findByRequisition_RequisitionId(Long requisitionId);
}