BEGIN;

-- =========================================================================
-- PRE-SEED PATCH: Allow active shifts to exist by letting clock_out be NULL
-- =========================================================================
ALTER TABLE worker_shifts ALTER COLUMN clock_out DROP NOT NULL;

-- =========================================================================
-- 0. COMPLETE FACTORY RESET (Clears data & resets auto-incrementing counters)
-- =========================================================================
TRUNCATE TABLE 
    worker_shifts, 
    store_expenses, 
    transaction_items, 
    sales_transactions, 
    employees, 
    all_members, 
    delivery_items, 
    deliveries, 
    orders, 
    store_inventory, 
    products, 
    suppliers, 
    categories, 
    branches 
RESTART IDENTITY CASCADE;

-- =========================================================================
-- 1. BRANCHES (20 Rows)
-- =========================================================================
INSERT INTO branches (branch_name, address) VALUES
('7-Eleven Siam Paragon', '991 Rama I Rd, Pathum Wan, Bangkok'),
('7-Eleven Silom Soi 2', '22 Silom Rd, Bang Rak, Bangkok'),
('7-Eleven Sukhumvit 11', '15 Sukhumvit Rd, Watthana, Bangkok'),
('7-Eleven Asoke Junction', '21 Asoke Montri Rd, Khlong Toei, Bangkok'),
('7-Eleven Thonglor Soi 10', '142 Thonglor Rd, Watthana, Bangkok'),
('7-Eleven Ekkamai BTS', '2 Executive St, Watthana, Bangkok'),
('7-Eleven Ladprao Crossing', '44 Ladprao Rd, Chatuchak, Bangkok'),
('7-Eleven Chatuchak Market', 'Kamphaeng Phet 2 Rd, Chatuchak, Bangkok'),
('7-Eleven Samyan Mitrtown', '944 Rama IV Rd, Pathum Wan, Bangkok'),
('7-Eleven Ari Station', '34 Phahonyothin Rd, Phaya Thai, Bangkok'),
('7-Eleven Huai Khwang', '11 Ratchadaphisek Rd, Huai Khwang, Bangkok'),
('7-Eleven Phaya Thai Link', '88 Phaya Thai Rd, Ratchathewi, Bangkok'),
('7-Eleven Ratchathewi', '205 Phetchaburi Rd, Ratchathewi, Bangkok'),
('7-Eleven MBK Center', '444 Phayathai Rd, Pathum Wan, Bangkok'),
('7-Eleven Sathorn Thani', '90 Sathorn Nua Rd, Bang Rak, Bangkok'),
('7-Eleven Khlong Toei', '50 Rama IV Rd, Khlong Toei, Bangkok'),
('7-Eleven Phra Khanong', '109 Sukhumvit 71 Rd, Watthana, Bangkok'),
('7-Eleven Bang Na Inter', '3235 Sukhumvit Rd, Bang Na, Bangkok'),
('7-Eleven Ramkhamhaeng', '2345 Ramkhamhaeng Rd, Bang Kapi, Bangkok'),
('7-Eleven Bang Kapi Mall', '3108 Lat Phrao Rd, Bang Kapi, Bangkok');

-- =========================================================================
-- 2. CATEGORIES (20 Rows)
-- =========================================================================
INSERT INTO categories (category_name, subcategory_name) VALUES
('FOOD', 'READY TO EAT MEALS'),
('FOOD', 'CHIPS'),
('FOOD', 'ICE CREAM'),
('FOOD', 'CHOCOLATES'),
('FOOD', 'BREAD'),
('DRINKS', 'ALCOHOL'),
('DRINKS', 'SOFT DRINKS'),
('DRINKS', 'WATER'),
('DRINKS', 'ENERGY DRINKS'),
('DRINKS', 'DAIRY'),
('DRINKS', 'ALL CAFE'),
('ELECTRONICS', 'EARPHONES'),
('ELECTRONICS', 'CHARGERS'),
('ELECTRONICS', 'SMARTPHONES'),
('ELECTRONICS', 'FLIP PHONES'),
('MEDICINAL', 'BAND AIDS'),
('MEDICINAL', 'PILLS'),
('MEDICINAL', 'MEDICINAL SYRUPS'),
('HYGIENE', 'SKIN CARE'),
('HYGIENE', 'BODY WASH');

-- =========================================================================
-- 3. PRODUCTS (20 Rows)
-- =========================================================================
INSERT INTO products (category_id, product_name, price) VALUES
(1, 'Ezygo Pork Gyoza Box', 39.00),
(2, 'Lays Rock Salt Chips 50g', 25.00),
(3, 'Nestle Extreme Chocolate Cone', 30.00),
(4, 'KitKat 4-Finger Milk Chocolate', 20.00),
(5, 'Farmhouse Whole Wheat Bread', 34.00),
(6, 'Chang Beer Classic 320ml Can', 38.00),
(7, 'Coca-Cola Zero Sugar 325ml', 16.00),
(8, 'Singha Drinking Water 600ml', 7.00),
(9, 'M-150 Energy Drink 150ml', 12.00),
(10, 'Meiji Pasteurized Milk 450ml', 27.00),
(11, 'All Cafe Iced Signature Latte', 45.00),
(12, '7-Eleven Bass Wired Earphones', 199.00),
(13, 'Remax Fast Charging Adapter', 250.00),
(14, 'True Alpha 5G Smartphone', 2990.00),
(15, 'Nokia 105 Classic Flip Phone', 790.00),
(16, 'Tiger Plast Clear Band-Aids 10s', 25.00),
(17, 'Tylenol 500mg Paracetamol 10s', 22.00),
(18, 'Sara Children Paracetamol Syrup', 45.00),
(19, 'Smooth E Babyface Gel 2 oz', 125.00),
(20, 'Shokubutsu Shower Cream', 65.00);

-- =========================================================================
-- 4. STORE INVENTORY (20 Rows)
-- =========================================================================
-- FIXED: Expired items are set to '2026-07-11' (today's current context date)
-- This passes the check constraint while successfully flagging expired metrics
INSERT INTO store_inventory (store_id, product_id, stock_quantity, expiration_date) VALUES
(1, 1, 5, '2026-07-11'),   -- EXPIRED TODAY (Triggers fn_check_expired_products & alerts)
(1, 2, 8, '2026-12-31'),   -- LOW STOCK ALERT (<= 10 units)
(1, 3, 50, '2026-07-11'),  -- EXPIRED TODAY
(1, 4, 3, '2026-07-15'),   
(1, 5, 45, '2026-07-25'),  
(2, 6, 80, '2026-08-15'),
(2, 7, 110, '2026-09-18'),
(3, 8, 250, '2026-10-01'),
(3, 9, 140, '2026-11-12'),
(4, 10, 65, '2026-07-20'),
(4, 11, 35, '2026-07-22'),
(5, 12, 15, '2027-01-01'),
(5, 13, 25, '2027-01-01'),
(1, 14, 12, '2027-06-01'),
(2, 15, 18, '2027-06-01'),
(3, 16, 75, '2027-03-15'),
(4, 17, 130, '2027-04-22'),
(5, 18, 40, '2026-08-10'),
(1, 19, 28, '2026-09-05'),
(2, 20, 55, '2026-09-20');

-- =========================================================================
-- 5. SUPPLIERS (20 Rows)
-- =========================================================================
INSERT INTO suppliers (company_name, contact_name, phone_number) VALUES
('CP All Distribution Co', 'Somsak Devakula', '+66-2-123-4567'),
('Thai Beverage Logistics', 'Vichai Sirivadhanabhakdi', '+66-2-987-6543'),
('Coca-Cola Amatil Thailand', 'Aryan Gurnani', '+66-81-555-0199'),
('Osotspa Public Co Ltd', 'Thanakorn Osathanugrah', '+66-89-444-0122'),
('CP-Meiji Co Ltd', 'Pinyada Mild', '+66-2-333-4444'),
('Sino-Pacific Trading Co', 'Kitti Prasertsuwan', '+66-2-888-9999'),
('Remax Thailand Corp', 'Natthapong Udomwan', '+66-83-777-6655'),
('True Distribution & Sales', 'Somchai Chearavanont', '+66-2-666-1111'),
('DKSH Thailand Logistics', 'Prapas Limbandhu', '+66-2-444-5555'),
('Tigerplast Manufacturing', 'Sunisa Raksasikorn', '+66-34-111-222'),
('Olic Thailand Ltd', 'Malee Jitrak', '+66-2-777-8888'),
('Smooth-E Co Ltd', 'Chatchai Phromsiri', '+66-2-555-1234'),
('Lion Corporation Thailand', 'Siriporn Petchkrai', '+66-2-444-7777'),
('Unilever Thai Trading Ltd', 'Wanchai Tangnoi', '+66-2-333-2222'),
('Berli Jucker Public Co', 'Narongrit Pipat', '+66-2-111-0000'),
('DHAS Stationery Industry', 'Adisorn Chokwatana', '+66-2-999-8888'),
('Double A Public Co Ltd', 'Anong Yindee', '+66-38-444-555'),
('President Bakery Public Co', 'Preecha Klong', '+66-2-777-1111'),
('Three Ladies Food Co', 'Niran Wattana', '+66-2-888-3333'),
('Thai Preserved Food Factory', 'Santi Bhirombhakdi', '+66-2-999-4444');

-- =========================================================================
-- 6. ORDERS (20 Rows)
-- =========================================================================
INSERT INTO orders (store_id, product_id, order_date, quantity, order_status) VALUES
(1, 1, '2026-07-01', 100, 'COMPLETED'),
(1, 2, '2026-07-01', 100, 'COMPLETED'),
(1, 3, '2026-07-02', 150, 'IN PROCESS'),
(1, 4, '2026-07-02', 100, 'COMPLETED'),
(1, 5, '2026-07-03', 100, 'ORDER SENT'),
(2, 6, '2026-07-03', 200, 'COMPLETED'),
(2, 7, '2026-07-03', 100, 'COMPLETED'),
(3, 8, '2026-07-04', 300, 'COMPLETED'),
(3, 9, '2026-07-04', 100, 'COMPLETED'),
(4, 10, '2026-07-05', 100, 'ORDER SENT'),
(4, 11, '2026-07-05', 150, 'IN PROCESS'),
(5, 12, '2026-07-05', 50, 'COMPLETED'),
(5, 13, '2026-07-06', 50, 'COMPLETED'),
(1, 14, '2026-07-06', 10, 'COMPLETED'),
(2, 15, '2026-07-06', 20, 'COMPLETED'),
(3, 16, '2026-07-07', 100, 'COMPLETED'),
(4, 17, '2026-07-07', 100, 'COMPLETED'),
(5, 18, '2026-07-07', 100, 'IN PROCESS'),
(1, 19, '2026-07-08', 50, 'COMPLETED'),
(2, 20, '2026-07-08', 100, 'COMPLETED');

-- =========================================================================
-- 7. DELIVERIES (20 Rows)
-- =========================================================================
INSERT INTO deliveries (store_id, supplier_id, delivery_date, driver_name, driver_phone, license_plate) VALUES
(1, 1, '2026-07-02 05:00:00+07', 'Driver Somchai', '+66-85-111-2221', '1กข-5001'),
(2, 2, '2026-07-02 05:30:00+07', 'Driver Somsak', '+66-85-111-2222', '1กข-5002'),
(3, 3, '2026-07-03 06:00:00+07', 'Driver Anupong', '+66-85-111-2223', '1กข-5003'),
(4, 4, '2026-07-03 04:15:00+07', 'Driver Prasan', '+66-85-111-2224', '1กข-5004'),
(5, 5, '2026-07-04 05:00:00+07', 'Driver Niran', '+66-85-111-2225', '1กข-5005'),
(1, 6, '2026-07-04 06:20:00+07', 'Driver Kittirat', '+66-85-111-2226', '1กข-5006'),
(2, 7, '2026-07-04 04:50:00+07', 'Driver Preecha', '+66-85-111-2227', '1กข-5007'),
(3, 8, '2026-07-05 05:10:00+07', 'Driver Thanawat', '+66-85-111-2228', '1กข-5008'),
(4, 9, '2026-07-05 05:45:00+07', 'Driver Sarawut', '+66-85-111-2229', '1กข-5009'),
(5, 10, '2026-07-06 04:00:00+07', 'Driver Boonmee', '+66-85-111-2230', '1กข-5010'),
(1, 11, '2026-07-06 06:12:00+07', 'Driver Chaiya', '+66-85-111-2231', '1กข-5011'),
(2, 12, '2026-07-06 05:30:00+07', 'Driver Wanchai', '+66-85-111-2232', '1กข-5012'),
(3, 13, '2026-07-07 05:00:00+07', 'Driver Sukit', '+66-85-111-2233', '1กข-5013'),
(4, 14, '2026-07-07 04:30:00+07', 'Driver Sompong', '+66-85-111-2234', '1กข-5014'),
(5, 15, '2026-07-07 05:15:00+07', 'Driver Narong', '+66-85-111-2235', '1กข-5015'),
(1, 16, '2026-07-08 05:00:00+07', 'Driver Adisorn', '+66-85-111-2236', '1กข-5016'),
(2, 17, '2026-07-08 05:40:00+07', 'Driver Chatchai', '+66-85-111-2237', '1กข-5017'),
(3, 18, '2026-07-08 06:00:00+07', 'Driver Piyabutr', '+66-85-111-2238', '1กข-5018'),
(4, 19, '2026-07-09 04:10:00+07', 'Driver Weera', '+66-85-111-2239', '1กข-5019'),
(5, 20, '2026-07-09 05:25:00+07', 'Driver Yuttana', '+66-85-111-2240', '1กข-5020');

-- =========================================================================
-- 8. DELIVERY ITEMS (20 Rows)
-- =========================================================================
INSERT INTO delivery_items (delivery_id, product_id, quantity_delivered, expiration_date) VALUES
(1, 1, 100, '2026-07-11'), (2, 2, 100, '2026-12-31'), (3, 3, 150, '2026-07-11'), (4, 4, 100, '2026-07-15'), (5, 5, 100, '2026-07-25'),
(6, 6, 200, '2026-08-15'), (7, 7, 100, '2026-09-18'), (8, 8, 300, '2026-10-01'), (9, 9, 100, '2026-11-12'), (10, 10, 100, '2026-07-20'),
(11, 11, 150, '2026-07-22'), (12, 12, 50, '2027-01-01'),  (13, 13, 50, '2027-01-01'),  (14, 14, 10, '2027-06-01'),  (15, 15, 20, '2027-06-01'),
(16, 16, 100, '2027-03-15'), (17, 17, 100, '2027-04-22'), (18, 18, 100, '2026-08-10'), (19, 19, 50, '2026-09-05'),  (20, 20, 100, '2026-09-20');

-- =========================================================================
-- 9. ALL MEMBERS (20 Rows)
-- =========================================================================
INSERT INTO all_members (phone_number, points_balance) VALUES
('+66-81-123-4501', 150), ('+66-81-123-4502', 340), ('+66-81-123-4503', 0),   ('+66-81-123-4504', 1250), ('+66-81-123-4505', 920),
('+66-81-123-4506', 450), ('+66-81-123-4507', 80),  ('+66-81-123-4508', 610), ('+66-81-123-4509', 2100), ('+66-81-123-4510', 550),
('+66-81-123-4511', 120), ('+66-81-123-4512', 880), ('+66-81-123-4513', 35),  ('+66-81-123-4514', 420),  ('+66-81-123-4515', 730),
('+66-81-123-4516', 900), ('+66-81-123-4517', 15),  ('+66-81-123-4518', 640), ('+66-81-123-4519', 1150), ('+66-81-123-4520', 230);

-- =========================================================================
-- 10. EMPLOYEES (20 Rows)
-- =========================================================================
INSERT INTO employees (store_id, employee_name, role_type) VALUES
(1, 'Ayush Tripathi', 'MANAGER'), (2, 'Aryan Gurnani', 'MANAGER'), (3, 'Pinyada Mild', 'MANAGER'), 
(1, 'Tawan Prom', 'CASHIER'), (2, 'Piyanut Wong', 'CASHIER'), (3, 'Sarawut Udom', 'CASHIER'), 
(4, 'Kamonwan Met', 'CASHIER'), (5, 'Teerapat Jai', 'CASHIER'), (1, 'Worawan Dee', 'CASHIER'), 
(2, 'Thanakrit Siri', 'CASHIER'), (3, 'Pornthip Sae', 'CASHIER'), (4, 'Anuchit Phos', 'CASHIER'), 
(5, 'Siriluck Sook', 'CASHIER'), (1, 'Phakphum Boon', 'RESTOCKER'), (2, 'Rattana Chok', 'RESTOCKER'), 
(3, 'Panupong Sang', 'RESTOCKER'), (1, 'Kittipong Jan', 'JANITOR'), (2, 'Supaporn In', 'JANITOR'), 
(1, 'Paveena Yim', 'SECURITY'), (2, 'Surasak Klai', 'SECURITY');

-- =========================================================================
-- 11. SALES TRANSACTIONS (20 Rows)
-- =========================================================================
INSERT INTO sales_transactions (store_id, member_id, phone_number, employee_id, total_amount, transaction_date, payment_method) VALUES
(1, 1, '+66-81-123-4501', 4, 39.00, '2026-07-08 08:30:00+07', 'CASH'),
(1, 2, '+66-81-123-4502', 4, 50.00, '2026-07-08 09:15:00+07', 'CREDIT_CARD'),
(1, NULL, NULL, 4, 30.00, '2026-07-08 12:00:00+07', 'DEBIT_CARD'),
(1, 4, '+66-81-123-4504', 4, 40.00, '2026-07-08 14:22:00+07', 'TRUE_MONEY'),
(2, 5, '+66-81-123-4505', 5, 34.00, '2026-07-08 19:45:00+07', 'SCAN'),
(1, NULL, NULL, 4, 38.00, '2026-07-09 08:10:00+07', 'CASH'),
(1, 7, '+66-81-123-4507', 4, 32.00, '2026-07-09 10:12:00+07', 'CREDIT_CARD'),
(3, 8, '+66-81-123-4508', 6, 14.00, '2026-07-09 11:30:00+07', 'SCAN'),
(3, 9, '+66-81-123-4509', 6, 24.00, '2026-07-09 13:05:00+07', 'TRUE_MONEY'),
(3, NULL, NULL, 6, 54.00, '2026-07-09 16:50:00+07', 'CASH'),
(4, 11, '+66-81-123-4511', 7, 45.00, '2026-07-09 18:22:00+07', 'SCAN'),
(4, 12, '+66-81-123-4512', 7, 199.00, '2026-07-09 21:05:00+07', 'CREDIT_CARD'),
(1, 13, '+66-81-123-4513', 4, 250.00, '2026-07-10 07:15:00+07', 'DEBIT_CARD'),
(5, NULL, NULL, 8, 2990.00, '2026-07-10 09:40:00+07', 'TRUE_MONEY'),
(5, 15, '+66-81-123-4515', 8, 790.00, '2026-07-10 10:12:00+07', 'SCAN'),
(1, 16, '+66-81-123-4516', 4, 50.00, '2026-07-10 11:00:00+07', 'CASH'),
(2, NULL, NULL, 5, 22.00, '2026-07-10 13:19:00+07', 'CREDIT_CARD'),
(3, 18, '+66-81-123-4518', 6, 90.00, '2026-07-10 14:45:00+07', 'SCAN'),
(4, 19, '+66-81-123-4519', 7, 125.00, '2026-07-10 16:30:00+07', 'TRUE_MONEY'),
(5, 20, '+66-81-123-4520', 8, 65.00, '2026-07-10 17:55:00+07', 'CASH');

-- =========================================================================
-- 12. TRANSACTION ITEMS (20 Rows)
-- =========================================================================
INSERT INTO transaction_items (transaction_id, product_id, store_id, expiration_date, quantity, unit_price) VALUES
(1, 1, 1, '2026-07-11', 1, 39.00),
(2, 2, 1, '2026-12-31', 2, 25.00),
(3, 3, 1, '2026-07-11', 1, 30.00),
(4, 4, 1, '2026-07-15', 2, 20.00),
(5, 5, 2, '2026-07-25', 1, 34.00),
(6, 6, 1, '2026-08-15', 1, 38.00),
(7, 7, 1, '2026-09-18', 2, 16.00),
(8, 8, 3, '2026-10-01', 2, 7.00),
(9, 9, 3, '2026-11-12', 2, 12.00),
(10, 10, 3, '2026-07-20', 2, 27.00),
(11, 11, 4, '2026-07-22', 1, 45.00),
(12, 12, 4, '2027-01-01', 1, 199.00),
(13, 13, 1, '2027-01-01', 1, 250.00),
(14, 14, 5, '2027-06-01', 1, 2990.00),
(15, 15, 5, '2027-06-01', 1, 790.00),
(16, 16, 1, '2027-03-15', 2, 25.00),
(17, 17, 2, '2027-04-22', 1, 22.00),
(18, 18, 3, '2026-08-10', 2, 45.00),
(19, 19, 4, '2026-09-05', 1, 125.00),
(20, 20, 5, '2026-09-20', 1, 65.00);

-- =========================================================================
-- 13. STORE EXPENSES (20 Rows)
-- =========================================================================
INSERT INTO store_expenses (store_id, expense_type, amount, expense_date) VALUES
(1, 'RENT', 45000.00, '2026-07-08'),
(1, 'UTILITIES', 12450.00, '2026-07-08'),
(1, 'MAINTENANCE', 4500.00, '2026-07-08'),
(1, 'SALARIES', 32000.00, '2026-07-10'),
(1, 'INVENTORY_RESTOCK', 15000.00, '2026-07-10'),
(2, 'RENT', 42000.00, '2026-07-07'),
(3, 'RENT', 48000.00, '2026-07-07'),
(2, 'UTILITIES', 11800.00, '2026-07-08'),
(3, 'UTILITIES', 14200.00, '2026-07-08'),
(4, 'UTILITIES', 10900.00, '2026-07-08'),
(5, 'UTILITIES', 13100.00, '2026-07-08'),
(2, 'MAINTENANCE', 3200.00, '2026-07-08'),
(2, 'SALARIES', 31500.00, '2026-07-10'),
(3, 'SALARIES', 34000.00, '2026-07-10'),
(4, 'SALARIES', 29000.00, '2026-07-10'),
(5, 'SALARIES', 33000.00, '2026-07-10'),
(2, 'INVENTORY_RESTOCK', 18500.00, '2026-07-10'),
(3, 'INVENTORY_RESTOCK', 22000.00, '2026-07-10'),
(4, 'INVENTORY_RESTOCK', 14000.00, '2026-07-10'),
(5, 'INVENTORY_RESTOCK', 19000.00, '2026-07-10');

-- =========================================================================
-- 14. WORKER SHIFTS (20 Rows)
-- =========================================================================
-- FIXED: Row 20 represents a true ACTIVE shift where clock_out IS NULL
INSERT INTO worker_shifts (employee_id, store_id, clock_in, clock_out, shift_status) VALUES
(4, 1, '2026-07-09 06:00:00+07', '2026-07-09 14:00:00+07', 'COMPLETED'), 
(4, 1, '2026-07-10 06:00:00+07', '2026-07-10 14:00:00+07', 'COMPLETED'),
(1, 1, '2026-07-09 08:00:00+07', '2026-07-09 16:00:00+07', 'COMPLETED'),
(2, 2, '2026-07-09 08:00:00+07', '2026-07-09 16:00:00+07', 'COMPLETED'),
(3, 3, '2026-07-09 08:00:00+07', '2026-07-09 16:00:00+07', 'COMPLETED'),
(5, 2, '2026-07-09 06:00:00+07', '2026-07-09 14:00:00+07', 'COMPLETED'),
(6, 3, '2026-07-09 06:00:00+07', '2026-07-09 14:00:00+07', 'COMPLETED'),
(7, 4, '2026-07-09 06:00:00+07', '2026-07-09 14:00:00+07', 'COMPLETED'),
(8, 5, '2026-07-09 06:00:00+07', '2026-07-09 14:00:00+07', 'COMPLETED'),
(9, 1, '2026-07-09 14:00:00+07', '2026-07-09 22:00:00+07', 'COMPLETED'),
(10, 2, '2026-07-09 14:00:00+07', '2026-07-09 22:00:00+07', 'COMPLETED'),
(11, 3, '2026-07-09 14:00:00+07', '2026-07-09 22:00:00+07', 'COMPLETED'),
(12, 4, '2026-07-09 14:00:00+07', '2026-07-09 22:00:00+07', 'COMPLETED'),
(13, 5, '2026-07-09 14:00:00+07', '2026-07-09 22:00:00+07', 'COMPLETED'),
(14, 1, '2026-07-10 08:00:00+07', '2026-07-10 16:00:00+07', 'COMPLETED'),
(15, 2, '2026-07-10 08:00:00+07', '2026-07-10 16:00:00+07', 'COMPLETED'),
(16, 3, '2026-07-10 08:00:00+07', '2026-07-10 16:00:00+07', 'COMPLETED'),
(17, 1, '2026-07-10 06:00:00+07', '2026-07-10 14:00:00+07', 'ABSENT'),
(18, 2, '2026-07-10 06:00:00+07', '2026-07-10 14:00:00+07', 'CANCELED'),
(19, 1, '2026-07-11 07:00:00+07', NULL, 'ACTIVE');                  -- ACTIVE SHIFT LOG

COMMIT;