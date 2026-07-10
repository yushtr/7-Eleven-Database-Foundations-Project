CREATE VIEW inventory_stock_view AS 
SELECT p.product_id, p.product_name, c.category_id, c.category_name, c.subcategory_name, s.stock_quantity, s.expiration_date
FROM products AS p
JOIN categories as c USING (category_id)
JOIN store_inventory as s USING (product_id);

CREATE VIEW incoming_deliveries_view AS 
SELECT d.delivery_date, d.driver_name, d.driver_phone, d.license_plate, di.product_id, p.product_name, c.category_name, c.subcategory_name, di.quantity_delivered, di.expiration_date
FROM delivery_items AS di 
JOIN products AS p USING (product_id)
JOIN categories AS c USING (category_id)
JOIN deliveries AS d USING (delivery_id);

CREATE VIEW cashier_sales_view AS 
SELECT s.transaction_id, s.transaction_date, s.payment_method, s.total_amount, s.member_id, a.phone_number, a.points_balance, p.product_id, p.product_name, t.unit_price, t.quantity, c.category_id, c.category_name, c.subcategory_name
FROM sales_transactions AS s
JOIN transaction_items AS t USING (transaction_id)
LEFT JOIN all_members AS a USING (member_id)
JOIN products AS p USING (product_id)
JOIN categories AS c USING (category_id);

CREATE VIEW manager_inventory_alerts AS 
SELECT s.store_id, p.product_id, p.product_name, s.stock_quantity, s.expiration_date, c.category_id, c.subcategory_name
FROM store_inventory AS s
JOIN products AS p USING (product_id)
JOIN categories AS c USING (category_id)
WHERE s.stock_quantity <= 10 OR (s.expiration_date - CURRENT_DATE) <= 7;

CREATE VIEW manager_daily_financials AS 
SELECT 
    s.transaction_date::date AS sales_date,
    COALESCE(SUM(s.total_amount), 0.00) AS day_revenue, 
    COUNT(*) AS number_of_transactions_per_day, 
    COALESCE(AVG(s.total_amount), 0.00) AS average_amount_spent_per_customer
FROM sales_transactions AS s
GROUP BY s.transaction_date::date;

CREATE VIEW manager_daily_expenses AS 
SELECT COALESCE(SUM(s.amount), 0.00) as day_expense, COUNT(*) AS number_of_expenses_per_day, COALESCE(AVG(amount), 0.00) AS average_expense_per_day, MODE() WITHIN GROUP (ORDER BY expense_type) AS most_frequent_expense_type, expense_date
FROM store_expenses AS s 
GROUP BY expense_date; 

CREATE VIEW manager_daily_net_profit AS 
SELECT 
    COALESCE(f.sales_date, e.expense_date) AS net_profit_date,
    COALESCE(f.day_revenue, 0.00) AS day_revenue,
    COALESCE(e.day_expense, 0.00) AS day_expense,
    (COALESCE(f.day_revenue, 0.00) - COALESCE(e.day_expense, 0.00)) AS day_net_profit
FROM manager_daily_financials AS f
FULL OUTER JOIN manager_daily_expenses AS e ON f.sales_date = e.expense_date;

CREATE VIEW branch_product_summary_view AS
SELECT b.store_id, b.branch_name, COUNT(s.product_id) AS number_of_products, COALESCE(SUM(s.stock_quantity), 0) AS total_stock_quantity
FROM branches AS b
LEFT JOIN store_inventory AS s USING (store_id)
GROUP BY b.store_id, b.branch_name;

CREATE VIEW member_purchase_summary_view AS
SELECT a.member_id, a.phone_number, a.points_balance, COUNT(s.transaction_id) AS total_transactions, COALESCE(SUM(s.total_amount), 0.00) AS total_spent
FROM all_members AS a
LEFT JOIN sales_transactions AS s USING (member_id)
GROUP BY a.member_id, a.phone_number, a.points_balance;

CREATE VIEW employee_shift_summary_view AS
SELECT e.employee_id, e.employee_name, e.role_type, w.clock_in, w.clock_out, COALESCE(ROUND(EXTRACT(EPOCH FROM (w.clock_out - w.clock_in)) / 3600, 2), 0.00) AS hours_worked
FROM employees AS e
JOIN worker_shifts AS w USING (employee_id);

CREATE VIEW active_staff_view AS
SELECT e.store_id, e.employee_id, e.employee_name, e.role_type, w.clock_in
FROM employees AS e
JOIN worker_shifts AS w USING (employee_id)
WHERE w.clock_in IS NOT NULL
    AND w.clock_out IS NULL;

CREATE VIEW branch_staff_summary_view AS
SELECT b.store_id, b.branch_name, e.role_type, COUNT(e.employee_id) AS number_of_staff
FROM branches AS b
LEFT JOIN employees AS e USING (store_id)
GROUP BY b.store_id, b.branch_name, e.role_type;