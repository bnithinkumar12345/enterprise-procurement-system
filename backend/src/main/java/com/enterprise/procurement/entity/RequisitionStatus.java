package com.enterprise.procurement.entity;

public final class RequisitionStatus {

    public static final String DRAFT = "DRAFT";
    public static final String SUBMITTED = "SUBMITTED";
    public static final String PENDING_APPROVAL = "PENDING_APPROVAL";
    public static final String APPROVED = "APPROVED";
    public static final String REJECTED = "REJECTED";
    public static final String RETURNED = "RETURNED";
    public static final String AWAITING_SUPPLIER_ASSIGNMENT = "AWAITING_SUPPLIER_ASSIGNMENT";
    public static final String ORDER_CREATED = "ORDER_CREATED";

    private RequisitionStatus() {
    }
}
