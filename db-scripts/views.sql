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
SELECT 
    s.transaction_id, s.transaction_date, s.payment_method, s.total_amount, s.member_id, a.phone_number, a.points_balance, p.product_id, p.product_name, p.price, t.quantity,c.category_id, c.category_name, c.subcategory_name
FROM sales_transactions AS s
JOIN transaction_items AS t USING (transaction_id)
LEFT JOIN all_members AS a USING (member_id)
JOIN products AS p USING (product_id)
JOIN categories AS c USING (category_id);

CREATE VIEW manager_inventory_alerts AS 
SELECT p.product_id, s.stock_quantity, s.expiration_date, c.category_id, c.subcategory_name
FROM store_inventory AS s
JOIN products AS p USING (product_id)
JOIN categories AS c USING (category_id)
WHERE stock_quantity <= 10 OR (expiration_date - CURRENT_DATE) BETWEEN 0 AND 7;


CREATE VIEW manager_daily_financials AS 
SELECT COALESCE(SUM(s.total_amount), 0.00) AS day_revenue, COUNT(*) AS number_of_customers_per_day, COALESCE(AVG(total_amount), 0.00) AS average_amount_spent_per_customer, transaction_date AS sales_date
FROM sales_transactions AS s
GROUP BY transaction_date;

CREATE VIEW manager_daily_expenses AS 
SELECT COALESCE(SUM(s.amount), 0.00) as day_expense, COUNT(*) AS number_of_expenses_per_day, COALESCE(AVG(amount), 0.00) AS average_expense_per_day, MODE() WITHIN GROUP (ORDER BY expense_type) AS most_frequent_expense_type, expense_date
FROM store_expenses AS s 
GROUP BY expense_date; 

CREATE VIEW manager_daily_net_profit AS 
SELECT (f.day_revenue - e.day_expense) AS day_net_profit, f.sales_date AS net_profit_date
FROM manager_daily_expenses AS e
JOIN manager_daily_financials AS f ON f.sales_date = e.expense_date;


