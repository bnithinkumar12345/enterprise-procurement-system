package com.enterprise.procurement.repository;

import com.enterprise.procurement.entity.Requisition;
import com.enterprise.procurement.entity.RequisitionHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface RequisitionHistoryRepository extends JpaRepository<RequisitionHistory, Long> {

    List<RequisitionHistory> findByRequisition(Requisition requisition);

    List<RequisitionHistory> findByActionBy_UsernameOrderByActionDateDesc(String username);

    long countByRequisition_RequisitionIdAndStep(Long requisitionId, String step);

    @Query("SELECT COUNT(h) FROM RequisitionHistory h WHERE h.requisition.requisitionId = :reqId AND h.step LIKE 'Approved%' " +
           "AND h.historyId > (SELECT COALESCE(MAX(h2.historyId), 0) FROM RequisitionHistory h2 WHERE h2.requisition.requisitionId = :reqId AND h2.step IN ('Submitted', 'Returned'))")
    long countCurrentCycleApprovals(@org.springframework.data.repository.query.Param("reqId") Long requisitionId);
}