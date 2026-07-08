-- Products
ALTER TABLE products
ADD CONSTRAINT chk_products_price_non_negative
CHECK (price >= 0);

-- Store Inventory
ALTER TABLE store_inventory
ADD CONSTRAINT chk_store_inventory_stock_quantity_non_negative
CHECK (stock_quantity >= 0);

-- Orders
ALTER TABLE orders
ADD CONSTRAINT chk_orders_quantity_positive
CHECK (quantity > 0);

-- Delivery Items
ALTER TABLE delivery_items
ADD CONSTRAINT chk_delivery_items_quantity_delivered_positive
CHECK (quantity_delivered > 0);

-- Members
ALTER TABLE all_members
ADD CONSTRAINT chk_all_members_points_balance_non_negative
CHECK (points_balance >= 0);

-- Sales Transactions
ALTER TABLE sales_transactions
ADD CONSTRAINT chk_sales_transactions_total_amount_non_negative
CHECK (total_amount >= 0);

ALTER TABLE sales_transactions
ADD CONSTRAINT chk_sales_transactions_payment_method
CHECK (payment_method IN ('Cash', 'Credit Card', 'Debit Card', 'QR Payment', 'Mobile Banking'));

-- Transaction Items
ALTER TABLE transaction_items
ADD CONSTRAINT chk_transaction_items_quantity_positive
CHECK (quantity > 0);

ALTER TABLE transaction_items
ADD CONSTRAINT chk_transaction_items_unit_price_non_negative
CHECK (unit_price >= 0);

-- Store Expenses
ALTER TABLE store_expenses
ADD CONSTRAINT chk_store_expenses_amount_non_negative
CHECK (amount >= 0);

-- Worker Shifts
ALTER TABLE worker_shifts
ADD CONSTRAINT chk_worker_shifts_clock_out_after_clock_in
CHECK (clock_out > clock_in);

ALTER TABLE worker_shifts
ADD CONSTRAINT chk_worker_shifts_status
CHECK (shift_status IN ('Scheduled', 'Completed', 'Absent', 'Late', 'Cancelled'));