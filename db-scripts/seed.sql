INSERT INTO branches (store_id, branch_name, address)
VALUES
(1, 'Branch 1', 'Bangkok');

INSERT INTO categories (category_id, category_name, subcategory_name)
VALUES
(1, 'Snacks', 'Chips');

INSERT INTO products (product_id, category_id, product_name, price)
VALUES
(1, 1, 'Good Product', 29.50);

INSERT INTO suppliers (supplier_id, company_name, contact_name, phone_number)
VALUES
(1, 'Test Supplier Co.', 'Test Supplier', '0811111111');

INSERT INTO orders (order_id, store_id, product_id, quantity)
VALUES
(1, 1, 1, 50);

INSERT INTO deliveries
(delivery_id, store_id, supplier_id, delivery_date, driver_name, driver_phone, license_plate)
VALUES
(1, 1, 1, CURRENT_TIMESTAMP, 'Test Driver', '0822222222', 'TEST-123');

INSERT INTO delivery_items
(delivery_id, product_id, quantity_delivered, expiration_date)
VALUES
(1, 1, 10, '2026-12-31');

INSERT INTO all_members (member_id, phone_number, points_balance)
VALUES
(1, '0999999999', 100);

INSERT INTO employees (employee_id, store_id, employee_name, role_type)
VALUES
(1, 1, 'Test Employee', 'Cashier');

INSERT INTO sales_transactions
(transaction_id, store_id, member_id, employee_id, total_amount, transaction_date, payment_method)
VALUES
(1, 1, 1, 1, 200.00, CURRENT_TIMESTAMP, 'Cash');

INSERT INTO transaction_items
(transaction_id, product_id, expiration_date, quantity, unit_price)
VALUES
(1, 1, '2026-12-31', 2, 29.50);

INSERT INTO store_expenses
(expense_id, store_id, expense_type, amount, expense_date)
VALUES
(1, 1, 'Electricity', 500.00, CURRENT_DATE);

INSERT INTO worker_shifts
(shift_id, employee_id, store_id, clock_in, clock_out, shift_status)
VALUES
(1, 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '8 hours', 'Scheduled');