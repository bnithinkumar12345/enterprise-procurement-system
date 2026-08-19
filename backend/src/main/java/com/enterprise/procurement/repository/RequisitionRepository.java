package com.enterprise.procurement.repository;

import com.enterprise.procurement.entity.Requisition;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RequisitionRepository extends JpaRepository<Requisition, Long> {
    
    @EntityGraph(attributePaths = {"department", "category", "supplier", "createdBy"})
    Optional<Requisition> findById(Long id);

    @EntityGraph(attributePaths = {"department", "category", "supplier", "createdBy"})
    List<Requisition> findAllByOrderByCreatedAtDesc();

    @EntityGraph(attributePaths = {"department", "category", "supplier", "createdBy"})
    List<Requisition> findByCreatedBy_UsernameOrderByCreatedAtDesc(String username);

    @EntityGraph(attributePaths = {"department", "category", "supplier", "createdBy"})
    List<Requisition> findByStatusOrderByCreatedAtDesc(String status);

    long countByStatus(String status);

    long countByStatusIn(List<String> statuses);
}