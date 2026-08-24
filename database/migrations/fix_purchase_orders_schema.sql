ALTER TABLE purchase_orders ADD COLUMN IF NOT EXISTS delivery_date DATE;
ALTER TABLE purchase_orders ADD COLUMN IF NOT EXISTS total_amount NUMERIC(12,2);
