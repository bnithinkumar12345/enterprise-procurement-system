package com.enterprise.procurement.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
public class RequisitionCreateRequest {

    @NotBlank(message = "Title is required")
    private String title;

    private String justification;

    @NotNull(message = "Needed by date is required")
    private LocalDate neededBy;

    @NotNull(message = "Category is required")
    private Long categoryId;

    private Long supplierId;

    private String priority;

    @Valid
    @NotEmpty(message = "Requisition must contain at least one line item")
    private List<LineItemRequest> items;

    @Getter
    @Setter
    public static class LineItemRequest {
        @NotBlank(message = "Item description is required")
        private String description;

        @NotNull(message = "Quantity is required")
        private Integer quantity;

        @NotNull(message = "Unit price is required")
        private java.math.BigDecimal unitPrice;
    }
}
