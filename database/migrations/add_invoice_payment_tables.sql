CREATE TABLE IF NOT EXISTS public.invoices (
    invoice_id BIGSERIAL PRIMARY KEY,
    invoice_number VARCHAR(255) NOT NULL UNIQUE,
    po_id BIGINT NOT NULL,
    invoice_date DATE,
    amount NUMERIC(12,2) NOT NULL,
    gst_amount NUMERIC(12,2),
    upload_url VARCHAR(255),
    status VARCHAR(255),
    verified_by BIGINT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_invoice_po
        FOREIGN KEY (po_id)
        REFERENCES public.purchase_orders(po_id),
    CONSTRAINT fk_invoice_verified_by
        FOREIGN KEY (verified_by)
        REFERENCES public.users(user_id)
);
CREATE TABLE IF NOT EXISTS public.payments (
    payment_id BIGSERIAL PRIMARY KEY,
    payment_reference VARCHAR(255) NOT NULL UNIQUE,
    invoice_id BIGINT NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    payment_date TIMESTAMP,
    status VARCHAR(255),
    paid_by BIGINT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_invoice
        FOREIGN KEY (invoice_id)
        REFERENCES public.invoices(invoice_id),
    CONSTRAINT fk_payment_user
        FOREIGN KEY (paid_by)
        REFERENCES public.users(user_id)
);
