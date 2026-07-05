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



