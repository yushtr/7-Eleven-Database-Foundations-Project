BEGIN;

ALTER TABLE worker_shifts ALTER COLUMN clock_out DROP NOT NULL;

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
-- Food: Meals & Fresh
('FOOD', 'CHILLED MEALS'),
('FOOD', 'FROZEN MEALS'),
('FOOD', 'INSTANT NOODLES'),
('FOOD', 'BAKERY & BREAD'),
('FOOD', 'DIM SUM & STEAMED BUNS'),
('FOOD', 'SAUSAGES & BOLOGNA'),
-- Food: Snacks & Sweets
('FOOD', 'CHIPS & CRISPS'),
('FOOD', 'CHOCOLATE & CANDY'),
('FOOD', 'ICE CREAM & DESSERTS'),
('FOOD', 'NUTS & SEEDS'),
('FOOD', 'DRIED FRUIT & SEAFOOD SNACKS'),

-- Beverages: Cold & Fresh
('BEVERAGES', 'DRINKING WATER'),
('BEVERAGES', 'SOFT DRINKS'),
('BEVERAGES', 'ENERGY & SPORTS DRINKS'),
('BEVERAGES', 'MILK & DAIRY'),
('BEVERAGES', 'RTD COFFEE & TEA'),
('BEVERAGES', 'JUICE & VITAMIN DRINKS'),
('BEVERAGES', 'ALCOHOLIC BEVERAGES'),
('BEVERAGES', 'ALL CAFE'),

-- Health & Beauty
('HEALTH & BEAUTY', 'FACIAL SKINCARE'),
('HEALTH & BEAUTY', 'BODY WASH & SOAP'),
('HEALTH & BEAUTY', 'SHAMPOO & HAIR CARE'),
('HEALTH & BEAUTY', 'ORAL CARE'),
('HEALTH & BEAUTY', 'DEODORANT & FRAGRANCE'),
('HEALTH & BEAUTY', 'TRAVEL SIZE COSMETICS'),

-- Medicine & First Aid (eXta Plus / General Pharmacy)
('MEDICINE & FIRST AID', 'PAIN RELIEF'),
('MEDICINE & FIRST AID', 'COUGH & COLD SYRUPS'),
('MEDICINE & FIRST AID', 'FIRST AID & BANDAGES'),
('MEDICINE & FIRST AID', 'INHALERS & BALMS'),
('MEDICINE & FIRST AID', 'VITAMINS & SUPPLEMENTS'),
('MEDICINE & FIRST AID', 'GASTROINTESTINAL RELIEF'),

-- Household & Groceries
('HOUSEHOLD', 'LAUNDRY DETERGENT'),
('HOUSEHOLD', 'DISHWASHING & CLEANING'),
('HOUSEHOLD', 'TISSUE & PAPER PRODUCTS'),
('HOUSEHOLD', 'COOKING ESSENTIALS'),

-- Electronics & IT
('ELECTRONICS', 'CABLES & CHARGERS'),
('ELECTRONICS', 'EARPHONES & AUDIO'),
('ELECTRONICS', 'POWER BANKS'),
('ELECTRONICS', 'SIM CARDS & TOP UP'),

-- Stationery & Miscellaneous
('STATIONERY & MISC', 'PENS & MARKERS'),
('STATIONERY & MISC', 'NOTEBOOKS & PAPER'),
('STATIONERY & MISC', 'UMBRELLAS & RAINGEAR');

-- =========================================================================
-- 3. PRODUCTS
-- =========================================================================
INSERT INTO products (category_id, product_name, price) VALUES
(1, 'Ezygo Pork Gyoza Box', 39.00),                     -- 1 (Chilled Meals)
(7, 'Lays Rock Salt Chips 50g', 25.00),                 -- 2 (Chips & Crisps)
(9, 'Nestle Extreme Chocolate Cone', 30.00),            -- 3 (Ice Cream & Desserts)
(8, 'KitKat 4-Finger Milk Chocolate', 20.00),           -- 4 (Chocolate & Candy)
(4, 'Farmhouse Whole Wheat Bread', 34.00),              -- 5 (Bakery & Bread)
(18, 'Chang Beer Classic 320ml Can', 38.00),            -- 6 (Alcoholic Beverages)
(13, 'Coca-Cola Zero Sugar 325ml', 16.00),              -- 7 (Soft Drinks)
(12, 'Singha Drinking Water 600ml', 7.00),              -- 8 (Drinking Water)
(14, 'M-150 Energy Drink 150ml', 12.00),                -- 9 (Energy & Sports Drinks)
(15, 'Meiji Pasteurized Milk 450ml', 27.00),            -- 10 (Milk & Dairy)
(19, 'All Cafe Iced Signature Latte', 45.00),           -- 11 (All Cafe)
(37, '7-Eleven Bass Wired Earphones', 199.00),          -- 12 (Earphones & Audio)
(36, 'Remax Fast Charging Adapter', 250.00),            -- 13 (Cables & Chargers)
(39, 'True Alpha 5G Smartphone', 2990.00),              -- 14 (Sim Cards & Top Up / Phones)
(39, 'Nokia 105 Classic Flip Phone', 790.00),           -- 15 (Sim Cards & Top Up / Phones)
(28, 'Tiger Plast Clear Band-Aids 10s', 25.00),         -- 16 (First Aid & Bandages)
(26, 'Tylenol 500mg Paracetamol 10s', 22.00),           -- 17 (Pain Relief)
(27, 'Sara Children Paracetamol Syrup', 45.00),         -- 18 (Cough & Cold Syrups)
(20, 'Smooth E Babyface Gel 2 oz', 125.00),             -- 19 (Facial Skincare)
(21, 'Shokubutsu Shower Cream', 65.00),                 -- 20 (Body Wash & Soap)

-- Food & Meals
(1, 'Ezygo Basil Minced Pork with Rice', 45.00),        -- 21
(2, 'CP Shrimp Wonton Soup', 55.00),                    -- 22
(3, 'Mama Tom Yum Kung Creamy 55g', 15.00),             -- 23
(3, 'Nissin Cup Noodles Seafood', 20.00),               -- 24
(4, 'Le Pan Banana Cake', 15.00),                       -- 25
(5, 'Jade Dragon Minced Pork Bun', 18.00),              -- 26
(6, 'CP Spicy Bologna 150g', 39.00),                    -- 27
(6, 'CP Smoked Chicken Frankfurter', 42.00),            -- 28
(7, 'Pringles Sour Cream & Onion 107g', 55.00),         -- 29
(8, 'Mentos Mint Roll', 15.00),                         -- 30
(9, 'Wall''s Magnum Classic', 55.00),                   -- 31
(10, 'Koh-Kae Peanuts Coconut 115g', 35.00),            -- 32
(11, 'Taro Fish Snack Original', 20.00),                -- 33
(11, 'Bento Squid Seafood Snack', 20.00),               -- 34

-- Beverages
(12, 'Crystal Drinking Water 1500ml', 14.00),           -- 35
(13, 'Sprite Original 325ml', 16.00),                   -- 36
(14, 'Sponsor Active Original', 12.00),                 -- 37
(15, 'Dutch Mill Drinking Yoghurt Mixed Berry', 22.00), -- 38
(16, 'Birdy Robusta Canned Coffee', 15.00),             -- 39
(16, 'Oishi Green Tea Honey Lemon', 20.00),             -- 40
(17, 'C-vitt Lemon Vitamin C 140ml', 16.00),            -- 41
(18, 'Leo Beer 500ml Can', 58.00),                      -- 42
(19, 'All Cafe Iced Americano', 40.00),                 -- 43

-- Health & Beauty
(20, 'Garnier Men TurboLight Face Wash', 139.00),       -- 44
(21, 'Parrot Botanicals Soap Pink', 18.00),             -- 45
(22, 'Sunsilk Pink Shampoo 120ml', 39.00),              -- 46
(23, 'Colgate Salt Toothpaste 150g', 45.00),            -- 47
(24, 'Nivea Men Roll-on Deodorant', 89.00),             -- 48
(25, 'Ponds BB Magic Powder', 35.00),                   -- 49

-- Medicine (eXta Plus)
(26, 'Gofen Ibuprofen 400mg 10s', 65.00),               -- 50
(28, 'Betadine Antiseptic Solution 15ml', 40.00),       -- 51
(29, 'Poy-Sian Mark II Inhaler', 24.00),                -- 52
(30, 'Blackmores Vitamin C 500mg', 199.00),             -- 53
(31, 'Eno Fruit Salt Lemon', 15.00),                    -- 54
(31, 'Flying Rabbit Gastric Mixture', 45.00),           -- 55

-- Household & Misc
(32, 'Breeze Excel Liquid Detergent', 39.00),           -- 56
(33, 'Sunlight Lemon Dishwashing Liquid', 25.00),       -- 57
(34, 'Scott Extra Toilet Tissue 2 Rolls', 35.00),       -- 58
(40, 'Lancer Spiral Pen 0.5 Blue', 10.00),              -- 59
(42, '7-Eleven Transparent Umbrella', 99.00);           -- 60

-- =========================================================================
-- 4. STORE INVENTORY
-- =========================================================================
INSERT INTO store_inventory (store_id, product_id, stock_quantity, expiration_date) VALUES
(1, 1, 5, '2026-07-11'),   (1, 2, 8, '2026-12-31'),   (1, 3, 50, '2026-07-11'),  
(1, 4, 3, '2026-07-15'),   (1, 5, 45, '2026-07-25'),  (2, 6, 80, '2026-08-15'),
(2, 7, 110, '2026-09-18'), (3, 8, 250, '2026-10-01'), (3, 9, 140, '2026-11-12'),
(4, 10, 65, '2026-07-20'), (4, 11, 35, '2026-07-22'), (5, 12, 15, '2027-01-01'),
(5, 13, 25, '2027-01-01'), (1, 14, 12, '2027-06-01'), (2, 15, 18, '2027-06-01'),
(3, 16, 75, '2027-03-15'), (4, 17, 130, '2027-04-22'),(5, 18, 40, '2026-08-10'),
(1, 19, 28, '2026-09-05'), (2, 20, 55, '2026-09-20'), (1, 21, 12, '2026-07-15'),  
(2, 22, 6, '2026-07-14'),  (5, 25, 15, '2026-07-18'), (1, 26, 25, '2026-07-14'),  
(2, 27, 40, '2026-08-01'), (3, 28, 35, '2026-08-01'), (3, 43, 50, '2026-07-13'),  
(3, 38, 40, '2026-07-25'), (3, 23, 150, '2027-02-01'),(4, 24, 120, '2027-02-01'), 
(4, 29, 45, '2027-05-10'), (5, 30, 80, '2027-10-01'), (1, 31, 60, '2026-12-01'),  
(2, 32, 55, '2027-03-15'), (3, 33, 90, '2027-04-20'), (4, 34, 85, '2027-04-20'),  
(5, 35, 200, '2027-11-01'),(1, 36, 150, '2027-08-15'),(2, 37, 130, '2027-06-10'), 
(4, 39, 110, '2027-09-01'),(5, 40, 160, '2027-05-01'),(1, 41, 85, '2027-01-15'),  
(2, 42, 140, '2027-04-01'),(4, 44, 20, '2028-06-01'), (5, 45, 45, '2029-01-01'),  
(1, 46, 30, '2028-11-01'), (2, 47, 40, '2028-12-01'), (3, 48, 25, '2028-08-15'),  
(4, 49, 50, '2028-10-10'), (5, 50, 60, '2028-05-01'), (1, 51, 15, '2029-03-01'),  
(2, 52, 120, '2028-07-01'),(3, 53, 9, '2028-01-01'),  (4, 54, 75, '2028-04-15'),  
(5, 55, 35, '2027-11-20'), (1, 56, 40, '2029-01-01'), (2, 57, 55, '2029-01-01'),  
(3, 58, 80, '2030-01-01'), (4, 59, 100, '2030-01-01'),(5, 60, 4, '2030-01-01'),

-- Store 6: Ekkamai BTS (Heavy on quick meals & drinks)
(6, 1, 45, '2026-07-14'), (6, 11, 80, '2026-07-15'), (6, 36, 150, '2027-08-15'),
-- Store 7: Ladprao Crossing (Snacks and basic meds)
(7, 2, 60, '2026-12-31'), (7, 13, 200, '2027-08-15'), (7, 50, 40, '2028-05-01'),
-- Store 8: Chatuchak Market (Water, energy drinks, and umbrellas!)
(8, 8, 300, '2026-10-01'), (8, 9, 150, '2026-11-12'), (8, 60, 50, '2030-01-01'),
-- Store 9: Samyan Mitrtown (Student heavy: Instant noodles & coffee)
(9, 23, 200, '2027-02-01'), (9, 24, 180, '2027-02-01'), (9, 43, 85, '2026-07-13'),
-- Store 10: Ari Station (Premium skincare and bakery)
(10, 5, 50, '2026-07-25'), (10, 19, 30, '2026-09-05'), (10, 44, 25, '2028-06-01'),
-- Store 11: Huai Khwang (Late night spot: Beer and hot snacks)
(11, 26, 60, '2026-07-14'), (11, 42, 250, '2027-04-01'), (11, 6, 180, '2026-08-15'),
-- Store 12: Phaya Thai Link (Quick transit essentials)
(12, 10, 40, '2026-07-20'), (12, 12, 15, '2027-01-01'), (12, 16, 50, '2027-03-15'),
-- Store 13: Ratchathewi (Mixed residential goods)
(13, 34, 90, '2027-04-20'), (13, 56, 45, '2029-01-01'), (13, 58, 100, '2030-01-01'),
-- Store 14: MBK Center (Tourist heavy: Candy, chips, and inhalers)
(14, 4, 120, '2026-07-15'), (14, 7, 200, '2026-09-18'), (14, 52, 300, '2028-07-01'),
-- Store 15: Sathorn Thani (Office workers: Mints, pens, and coffee)
(15, 30, 85, '2027-10-01'), (15, 39, 140, '2027-09-01'), (15, 59, 150, '2030-01-01'),
-- Store 16: Khlong Toei (Household goods and staples)
(16, 35, 250, '2027-11-01'), (16, 57, 60, '2029-01-01'), (16, 45, 55, '2029-01-01'),
-- Store 17: Phra Khanong (Residential staples)
(17, 21, 20, '2026-07-15'), (17, 28, 45, '2026-08-01'), (17, 47, 60, '2028-12-01'),
-- Store 18: Bang Na Inter (Large format store: Bulk buys)
(18, 3, 100, '2026-07-11'), (18, 31, 80, '2026-12-01'), (18, 40, 200, '2027-05-01'),
-- Store 19: Ramkhamhaeng (University area)
(19, 29, 70, '2027-05-10'), (19, 38, 55, '2026-07-25'), (19, 49, 65, '2028-10-10'),
-- Store 20: Bang Kapi Mall (High foot traffic mix)
(20, 22, 15, '2026-07-14'), (20, 33, 110, '2027-04-20'), (20, 54, 90, '2028-04-15');

-- =========================================================================
-- 5. SUPPLIERS
-- =========================================================================
INSERT INTO suppliers (company_name, contact_name, phone_number) VALUES
('CP All Distribution Co', 'Somsak Devakula', '+66-2-123-4567'),               -- 1
('Thai Beverage Logistics', 'Vichai Sirivadhanabhakdi', '+66-2-987-6543'),     -- 2
('Coca-Cola Amatil Thailand', 'Aryan Gurnani', '+66-81-555-0199'),             -- 3
('Osotspa Public Co Ltd', 'Thanakorn Osathanugrah', '+66-89-444-0122'),        -- 4
('CP-Meiji Co Ltd', 'Pinyada Mild', '+66-2-333-4444'),                         -- 5
('Sino-Pacific Trading Co', 'Kitti Prasertsuwan', '+66-2-888-9999'),           -- 6
('Remax Thailand Corp', 'Natthapong Udomwan', '+66-83-777-6655'),              -- 7
('True Distribution & Sales', 'Somchai Chearavanont', '+66-2-666-1111'),       -- 8
('DKSH Thailand Logistics', 'Prapas Limbandhu', '+66-2-444-5555'),             -- 9
('Tigerplast Manufacturing', 'Sunisa Raksasikorn', '+66-34-111-222'),          -- 10
('Olic Thailand Ltd', 'Malee Jitrak', '+66-2-777-8888'),                       -- 11
('Smooth-E Co Ltd', 'Chatchai Phromsiri', '+66-2-555-1234'),                   -- 12
('Lion Corporation Thailand', 'Siriporn Petchkrai', '+66-2-444-7777'),         -- 13
('Unilever Thai Trading Ltd', 'Wanchai Tangnoi', '+66-2-333-2222'),            -- 14
('Berli Jucker Public Co', 'Narongrit Pipat', '+66-2-111-0000'),               -- 15
('DHAS Stationery Industry', 'Adisorn Chokwatana', '+66-2-999-8888'),          -- 16
('Double A Public Co Ltd', 'Anong Yindee', '+66-38-444-555'),                  -- 17
('President Bakery Public Co', 'Preecha Klong', '+66-2-777-1111'),             -- 18
('Three Ladies Food Co', 'Niran Wattana', '+66-2-888-3333'),                   -- 19
('Thai Preserved Food Factory', 'Santi Bhirombhakdi', '+66-2-999-4444'),       -- 20

('Saha Pathanapibul Public Co', 'Boonsithi Chokwatana', '+66-2-293-9000'),     -- 21 (Mama Noodles, Household)
('Nissin Foods Thailand Ltd', 'Kiyoshi Miyake', '+66-2-363-2222'),             -- 22 (Cup Noodles)
('Nestle Thai Ltd', 'Victor Seah', '+66-2-657-8000'),                          -- 23 (Ice Cream, Coffee, Water)
('Boon Rawd Trading Co Ltd', 'Palit Bhirombhakdi', '+66-2-242-4444'),          -- 24 (Singha, Leo, Purra)
('Suntory PepsiCo Beverage Thailand', 'Ashish Joshi', '+66-2-610-2555'),       -- 25 (Pepsi, Lipton, Tea)
('Mondelez International Thailand', 'Pasutha P.', '+66-2-789-3333'),           -- 26 (Candy, Chocolate)
('Srinanaporn Marketing Public Co', 'Viwat Kraipit', '+66-2-434-6666'),        -- 27 (Bento Squid Snack)
('Taokaenoi Food & Marketing', 'Itthipat Peeradechapan', '+66-2-984-0666'),    -- 28 (Seaweed Snacks)
('Dutch Mill Co Ltd', 'Pornchai Sirikittikoon', '+66-2-881-2222'),             -- 29 (Dutch Mill, Dairy)
('Ajinomoto Sales Thailand', 'Ichiro Sakakura', '+66-2-247-7000'),             -- 30 (Birdy Coffee, MSG)
('Oishi Group Public Co', 'Nongnuch Buranasetkul', '+66-2-785-8888'),          -- 31 (Green Tea, Food)
('Kao Commercial Thailand', 'Yuji Shimizu', '+66-2-655-4444'),                 -- 32 (Biore, Magiclean)
('Johnson & Johnson Thailand', 'Vichai P.', '+66-2-320-1111'),                 -- 33 (Listerine, Skincare)
('Beiersdorf Thailand', 'Waraporn K.', '+66-2-236-0000'),                      -- 34 (Nivea, Eucerin)
('Mega Lifesciences Public Co', 'Vivek Dhawan', '+66-2-763-8999'),             -- 35 (Vitamins & Supplements)
('Reckitt Benckiser Thailand', 'Rohit Jindal', '+66-2-080-6000'),              -- 36 (Eno, Dettol)
('GSK Thailand', 'Viriya C.', '+66-2-659-3000'),                               -- 37 (Panadol, Sensodyne)
('Kimberly-Clark Thailand', 'Chakree S.', '+66-2-230-3000'),                   -- 38 (Scott Tissue, Kleenex)
('TCP Group', 'Saravoot Yoovidhya', '+66-2-312-3333'),                         -- 39 (Red Bull, Sponsor)
('Charoen Pokphand Foods', 'Prasit Boondoungprasert', '+66-2-625-8000');       -- 40 (CP Fresh Food, Sausages)

-- =========================================================================
-- 6. ORDERS
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
(2, 20, '2026-07-08', 100, 'COMPLETED'),

(1, 21, '2026-07-08', 100, 'COMPLETED'),    -- Basil Minced Pork 
(2, 22, '2026-07-09', 150, 'IN PROCESS'),   -- Wonton Soup (Pending delivery)
(3, 23, '2026-07-01', 300, 'COMPLETED'),    -- Mama Noodles (Bulk stock)
(4, 24, '2026-07-02', 200, 'COMPLETED'),    -- Cup Noodles
(5, 25, '2026-07-03', 100, 'COMPLETED'),    -- Banana Cake
(1, 26, '2026-07-10', 100, 'ORDER SENT'),   -- Pork Bun (Just ordered today)
(2, 27, '2026-07-04', 150, 'COMPLETED'),    -- Bologna
(3, 28, '2026-07-05', 100, 'COMPLETED'),    -- Frankfurter
(4, 31, '2026-07-06', 200, 'COMPLETED'),    -- Magnum Ice Cream
(5, 35, '2026-07-07', 500, 'COMPLETED'),    -- Crystal Water (Massive quantity)
(1, 36, '2026-07-08', 300, 'COMPLETED'),    -- Sprite
(2, 42, '2026-07-09', 200, 'IN PROCESS'),   -- Leo Beer (Pending delivery)
(3, 44, '2026-07-01', 50, 'COMPLETED'),     -- Garnier Face Wash
(4, 50, '2026-07-10', 100, 'ORDER SENT'),   -- Gofen (Just ordered today)
(5, 52, '2026-07-02', 200, 'COMPLETED'),    -- Poy-Sian Inhaler
(1, 56, '2026-07-03', 50, 'COMPLETED'),     -- Detergent
(2, 58, '2026-07-04', 100, 'COMPLETED'),    -- Toilet Tissue
(3, 59, '2026-07-05', 150, 'COMPLETED'),    -- Pens
(4, 60, '2026-07-09', 50, 'IN PROCESS'),    -- Umbrellas (Pending delivery)
(5, 38, '2026-07-08', 100, 'COMPLETED');    -- Dutch Mill Yoghurt

-- =========================================================================
-- 7. DELIVERIES
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
(5, 20, '2026-07-09 05:25:00+07', 'Driver Yuttana', '+66-85-111-2240', '1กข-5020'),

(1, 21, '2026-07-08 04:30:00+07', 'Driver Nattapong', '+66-85-111-2241', '2กค-6001'),
(2, 22, '2026-07-09 05:15:00+07', 'Driver Surachai', '+66-85-111-2242', '2กค-6002'),
(3, 23, '2026-07-01 04:00:00+07', 'Driver Kitti', '+66-85-111-2243', '2กค-6003'),
(4, 24, '2026-07-02 06:10:00+07', 'Driver Mongkol', '+66-85-111-2244', '2กค-6004'),
(5, 25, '2026-07-03 05:45:00+07', 'Driver Teera', '+66-85-111-2245', '2กค-6005'),
(1, 26, '2026-07-10 04:20:00+07', 'Driver Vachira', '+66-85-111-2246', '2กค-6006'),
(2, 27, '2026-07-04 05:00:00+07', 'Driver Panit', '+66-85-111-2247', '2กค-6007'),
(3, 28, '2026-07-05 06:30:00+07', 'Driver Supot', '+66-85-111-2248', '2กค-6008'),
(4, 31, '2026-07-06 04:40:00+07', 'Driver Pongsak', '+66-85-111-2249', '2กค-6009'),
(5, 35, '2026-07-07 05:25:00+07', 'Driver Apichart', '+66-85-111-2250', '2กค-6010'),
(1, 36, '2026-07-08 04:10:00+07', 'Driver Ekkachai', '+66-85-111-2251', '2กค-6011'),
(2, 40, '2026-07-09 05:50:00+07', 'Driver Tawan', '+66-85-111-2252', '2กค-6012'),
(3, 33, '2026-07-01 06:15:00+07', 'Driver Witoon', '+66-85-111-2253', '2กค-6013'),
(4, 34, '2026-07-10 04:30:00+07', 'Driver Prasert', '+66-85-111-2254', '2กค-6014'),
(5, 32, '2026-07-02 05:05:00+07', 'Driver Somsit', '+66-85-111-2255', '2กค-6015'),
(1, 30, '2026-07-03 05:35:00+07', 'Driver Nattapon', '+66-85-111-2256', '2กค-6016'),
(2, 29, '2026-07-04 06:00:00+07', 'Driver Chonlatit', '+66-85-111-2257', '2กค-6017'),
(3, 38, '2026-07-05 04:50:00+07', 'Driver Yotin', '+66-85-111-2258', '2กค-6018'),
(4, 37, '2026-07-09 05:15:00+07', 'Driver Krai', '+66-85-111-2259', '2กค-6019'),
(5, 39, '2026-07-08 04:25:00+07', 'Driver Manop', '+66-85-111-2260', '2กค-6020');

-- =========================================================================
-- 8. DELIVERY ITEMS (40 Rows)
-- =========================================================================
INSERT INTO delivery_items (delivery_id, product_id, quantity_delivered, expiration_date) VALUES
(1, 1, 100, '2026-07-12'), (2, 2, 100, '2026-12-31'), (3, 3, 150, '2026-07-12'), (4, 4, 100, '2026-07-15'), (5, 5, 100, '2026-07-25'),
(6, 6, 200, '2026-08-15'), (7, 7, 100, '2026-09-18'), (8, 8, 300, '2026-10-01'), (9, 9, 100, '2026-11-12'), (10, 10, 100, '2026-07-20'),
(11, 11, 150, '2026-07-22'), (12, 12, 50, '2027-01-01'),  (13, 13, 50, '2027-01-01'),  (14, 14, 10, '2027-06-01'),  (15, 15, 20, '2027-06-01'),
(16, 16, 100, '2027-03-15'), (17, 17, 100, '2027-04-22'), (18, 18, 100, '2026-08-10'), (19, 19, 50, '2026-09-05'),  (20, 20, 100, '2026-09-20'),

(21, 21, 100, '2026-07-15'),  -- Basil Minced Pork 
(22, 22, 150, '2026-07-14'),  -- Wonton Soup
(23, 23, 300, '2027-02-01'),  -- Mama Noodles
(24, 24, 200, '2027-02-01'),  -- Cup Noodles
(25, 25, 100, '2026-07-18'),  -- Banana Cake
(26, 26, 100, '2026-07-14'),  -- Pork Bun
(27, 27, 150, '2026-08-01'),  -- Bologna
(28, 28, 100, '2026-08-01'),  -- Frankfurter
(29, 31, 200, '2026-12-01'),  -- Magnum Ice Cream
(30, 35, 500, '2027-11-01'),  -- Crystal Water
(31, 36, 300, '2027-08-15'),  -- Sprite
(32, 42, 200, '2027-04-01'),  -- Leo Beer
(33, 44, 50,  '2028-06-01'),  -- Garnier Face Wash
(34, 50, 100, '2028-05-01'),  -- Gofen
(35, 52, 200, '2028-07-01'),  -- Poy-Sian Inhaler
(36, 56, 50,  '2029-01-01'),  -- Detergent
(37, 58, 100, '2030-01-01'),  -- Toilet Tissue
(38, 59, 150, '2030-01-01'),  -- Pens
(39, 60, 50,  '2030-01-01'),  -- Umbrellas
(40, 38, 100, '2026-07-25');  -- Dutch Mill Yoghurt

-- =========================================================================
-- 9. ALL MEMBERS (40 Rows)
-- =========================================================================
INSERT INTO all_members (phone_number, points_balance) VALUES
('+66-81-123-4501', 150), ('+66-81-123-4502', 340), ('+66-81-123-4503', 0),   ('+66-81-123-4504', 1250), ('+66-81-123-4505', 920),
('+66-81-123-4506', 450), ('+66-81-123-4507', 80),  ('+66-81-123-4508', 610), ('+66-81-123-4509', 2100), ('+66-81-123-4510', 550),
('+66-81-123-4511', 120), ('+66-81-123-4512', 880), ('+66-81-123-4513', 35),  ('+66-81-123-4514', 420),  ('+66-81-123-4515', 730),
('+66-81-123-4516', 900), ('+66-81-123-4517', 15),  ('+66-81-123-4518', 640), ('+66-81-123-4519', 1150), ('+66-81-123-4520', 230),

('+66-81-123-4521', 50),   ('+66-81-123-4522', 1100), ('+66-81-123-4523', 25),   ('+66-81-123-4524', 400),  ('+66-81-123-4525', 0),
('+66-81-123-4526', 75),   ('+66-81-123-4527', 3200), ('+66-81-123-4528', 180),  ('+66-81-123-4529', 540),  ('+66-81-123-4530', 210),
('+66-81-123-4531', 95),   ('+66-81-123-4532', 600),  ('+66-81-123-4533', 1500), ('+66-81-123-4534', 80),   ('+66-81-123-4535', 0),
('+66-81-123-4536', 310),  ('+66-81-123-4537', 490),  ('+66-81-123-4538', 820),  ('+66-81-123-4539', 1050), ('+66-81-123-4540', 60);

-- =========================================================================
-- 10. EMPLOYEES
-- =========================================================================
INSERT INTO employees (store_id, employee_name, role_type) VALUES
(1, 'Somchai Manager', 'MANAGER'),         -- 1
(2, 'Somsri Manager', 'MANAGER'),          -- 2
(3, 'Kitti Manager', 'MANAGER'),           -- 3
(1, 'Nattapong Cashier', 'CASHIER'),       -- 4
(2, 'Wipa Cashier', 'CASHIER'),            -- 5
(3, 'Pranee Cashier', 'CASHIER'),          -- 6
(4, 'Surachai Cashier', 'CASHIER'),        -- 7
(5, 'Sunisa Cashier', 'CASHIER'),          -- 8
(1, 'Piyapat Cashier', 'CASHIER'),         -- 9
(2, 'Tawan Cashier', 'CASHIER'),           -- 10
(3, 'Arun Cashier', 'CASHIER'),            -- 11
(4, 'Malee Cashier', 'CASHIER'),           -- 12
(5, 'Siri Cashier', 'CASHIER'),            -- 13
(1, 'Ekkachai Stock', 'RESTOCKER'),        -- 14
(2, 'Wichai Stock', 'RESTOCKER'),          -- 15
(3, 'Anan Stock', 'RESTOCKER'),            -- 16
(1, 'Niran Staff', 'CASHIER'),             -- 17
(2, 'Sopon Staff', 'CASHIER'),             -- 18
(1, 'Thaksin Security', 'SECURITY'),       -- 19
(2, 'Preecha Security', 'SECURITY'),       -- 20

-- Store 6: Ekkamai BTS
(6, 'Nadech Manager', 'MANAGER'),          -- 21
(6, 'Pornsawan Cashier', 'CASHIER'),       -- 22
(6, 'Siriporn Cashier', 'CASHIER'),        -- 23

-- Store 7: Ladprao Crossing
(7, 'Kittisak Manager', 'MANAGER'),        -- 24
(7, 'Jiraporn Cashier', 'CASHIER'),        -- 25
(7, 'Suphakit Cashier', 'CASHIER'),        -- 26

-- Store 8: Chatuchak Market (High volume, needs restockers)
(8, 'Panya Manager', 'MANAGER'),           -- 27
(8, 'Wandee Cashier', 'CASHIER'),          -- 28
(8, 'Boonmee Stock', 'RESTOCKER'),         -- 29

-- Store 9: Samyan Mitrtown
(9, 'Thawatchai Manager', 'MANAGER'),      -- 30
(9, 'Ratana Cashier', 'CASHIER'),          -- 31
(9, 'Samarn Cashier', 'CASHIER'),          -- 32

-- Store 10: Ari Station
(10, 'Chaloem Manager', 'MANAGER'),        -- 33
(10, 'Mali Cashier', 'CASHIER'),           -- 34
(10, 'Phanit Cashier', 'CASHIER'),         -- 35

-- Store 11: Huai Khwang (Late night spot, needs security)
(11, 'Arporn Manager', 'MANAGER'),         -- 36
(11, 'Kriang Cashier', 'CASHIER'),         -- 37
(11, 'Nongnuch Security', 'SECURITY'),     -- 38

-- Store 12: Phaya Thai Link
(12, 'Sunthorn Manager', 'MANAGER'),       -- 39
(12, 'Tasanee Cashier', 'CASHIER'),        -- 40
(12, 'Vichai Cashier', 'CASHIER'),         -- 41

-- Store 13: Ratchathewi
(13, 'Udom Manager', 'MANAGER'),           -- 42
(13, 'Kannika Cashier', 'CASHIER'),        -- 43
(13, 'Chatri Stock', 'RESTOCKER'),         -- 44

-- Store 14: MBK Center
(14, 'Sopa Manager', 'MANAGER'),           -- 45
(14, 'Phaibun Cashier', 'CASHIER'),        -- 46
(14, 'Rochana Cashier', 'CASHIER'),        -- 47

-- Store 15: Sathorn Thani
(15, 'Prasert Manager', 'MANAGER'),        -- 48
(15, 'Suda Cashier', 'CASHIER'),           -- 49
(15, 'Thitinan Security', 'SECURITY'),     -- 50

-- Store 16: Khlong Toei
(16, 'Narong Manager', 'MANAGER'),         -- 51
(16, 'Wimon Cashier', 'CASHIER'),          -- 52
(16, 'Mongkol Cashier', 'CASHIER'),        -- 53

-- Store 17: Phra Khanong
(17, 'Chaiya Manager', 'MANAGER'),         -- 54
(17, 'Darunee Cashier', 'CASHIER'),        -- 55
(17, 'Kanya Stock', 'RESTOCKER'),          -- 56

-- Store 18: Bang Na Inter
(18, 'Banjong Manager', 'MANAGER'),        -- 57
(18, 'Ladda Cashier', 'CASHIER'),          -- 58
(18, 'Pisit Cashier', 'CASHIER'),          -- 59

-- Store 19: Ramkhamhaeng
(19, 'Anusorn Manager', 'MANAGER'),        -- 60
(19, 'Penporn Cashier', 'CASHIER'),        -- 61
(19, 'Suriyan Security', 'SECURITY'),      -- 62

-- Store 20: Bang Kapi Mall
(20, 'Chanarong Manager', 'MANAGER'),      -- 63
(20, 'Nittaya Cashier', 'CASHIER'),        -- 64
(20, 'Somporn Cashier', 'CASHIER');        -- 65

-- =========================================================================
-- 11. SALES TRANSACTIONS
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
(5, 20, '+66-81-123-4520', 8, 65.00, '2026-07-10 17:55:00+07', 'CASH'),

(1, 21, '+66-81-123-4521', 4, 45.00, '2026-07-10 18:30:00+07', 'SCAN'),         -- Basil Minced Pork
(2, NULL, NULL, 5, 55.00, '2026-07-10 19:15:00+07', 'CASH'),                    -- Wonton Soup (Non-member)
(3, 23, '+66-81-123-4523', 6, 150.00, '2026-07-10 20:45:00+07', 'TRUE_MONEY'),  -- 10x Mama Noodles
(4, 24, '+66-81-123-4524', 7, 40.00, '2026-07-10 21:10:00+07', 'CASH'),         -- 2x Cup Noodles
(5, NULL, NULL, 8, 30.00, '2026-07-10 22:05:00+07', 'SCAN'),                    -- 2x Banana Cake (Non-member)
(1, 26, '+66-81-123-4526', 9, 36.00, '2026-07-11 06:15:00+07', 'TRUE_MONEY'),   -- 2x Pork Bun (Early morning shift cashier)
(2, 27, '+66-81-123-4527', 10, 117.00, '2026-07-11 07:30:00+07', 'CREDIT_CARD'),-- 3x Bologna
(3, 28, '+66-81-123-4528', 11, 84.00, '2026-07-11 08:05:00+07', 'SCAN'),        -- 2x Frankfurter
(4, NULL, NULL, 12, 55.00, '2026-07-11 08:45:00+07', 'CASH'),                   -- Magnum Ice Cream (Non-member)
(5, 30, '+66-81-123-4530', 13, 28.00, '2026-07-11 09:20:00+07', 'TRUE_MONEY'),  -- 2x Crystal Water
(1, 31, '+66-81-123-4531', 9, 32.00, '2026-07-11 10:10:00+07', 'CASH'),         -- 2x Sprite
(2, 32, '+66-81-123-4532', 10, 116.00, '2026-07-11 11:35:00+07', 'SCAN'),       -- 2x Leo Beer
(3, 33, '+66-81-123-4533', 11, 139.00, '2026-07-11 12:15:00+07', 'CREDIT_CARD'),-- Garnier Face Wash
(4, NULL, NULL, 12, 65.00, '2026-07-11 12:45:00+07', 'CASH'),                   -- Gofen (Non-member)
(5, 35, '+66-81-123-4535', 13, 48.00, '2026-07-11 13:05:00+07', 'TRUE_MONEY'),  -- 2x Poy-Sian Inhaler
(1, 36, '+66-81-123-4536', 4, 39.00, '2026-07-11 13:30:00+07', 'SCAN'),         -- Detergent
(2, 37, '+66-81-123-4537', 5, 70.00, '2026-07-11 14:12:00+07', 'CASH'),         -- 2x Toilet Tissue
(3, NULL, NULL, 6, 20.00, '2026-07-11 14:50:00+07', 'CASH'),                    -- 2x Pens (Non-member)
(4, 39, '+66-81-123-4539', 7, 99.00, '2026-07-11 15:15:00+07', 'DEBIT_CARD'),   -- Umbrella
(5, 40, '+66-81-123-4540', 8, 44.00, '2026-07-11 15:45:00+07', 'SCAN');         -- 2x Dutch Mill Yoghurt

-- =========================================================================
-- 12. TRANSACTION ITEMS
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
(20, 20, 5, '2026-09-20', 1, 65.00),

(21, 21, 1, '2026-07-15', 1, 45.00),  -- 1x Basil Minced Pork
(22, 22, 2, '2026-07-14', 1, 55.00),  -- 1x Wonton Soup
(23, 23, 3, '2027-02-01', 10, 15.00), -- 10x Mama Noodles (Bulk buy)
(24, 24, 4, '2027-02-01', 2, 20.00),  -- 2x Cup Noodles
(25, 25, 5, '2026-07-18', 2, 15.00),  -- 2x Banana Cake
(26, 26, 1, '2026-07-14', 2, 18.00),  -- 2x Pork Bun
(27, 27, 2, '2026-08-01', 3, 39.00),  -- 3x Bologna
(28, 28, 3, '2026-08-01', 2, 42.00),  -- 2x Frankfurter
(29, 31, 4, '2026-12-01', 1, 55.00),  -- 1x Magnum Ice Cream
(30, 35, 5, '2027-11-01', 2, 14.00),  -- 2x Crystal Water
(31, 36, 1, '2027-08-15', 2, 16.00),  -- 2x Sprite
(32, 42, 2, '2027-04-01', 2, 58.00),  -- 2x Leo Beer
(33, 44, 3, '2028-06-01', 1, 139.00), -- 1x Garnier Face Wash
(34, 50, 4, '2028-05-01', 1, 65.00),  -- 1x Gofen
(35, 52, 5, '2028-07-01', 2, 24.00),  -- 2x Poy-Sian Inhaler
(36, 56, 1, '2029-01-01', 1, 39.00),  -- 1x Detergent
(37, 58, 2, '2030-01-01', 2, 35.00),  -- 2x Toilet Tissue
(38, 59, 3, '2030-01-01', 2, 10.00),  -- 2x Pens
(39, 60, 4, '2030-01-01', 1, 99.00),  -- 1x Umbrella
(40, 38, 5, '2026-07-25', 2, 22.00);  -- 2x Dutch Mill Yoghurt

-- =========================================================================
-- 13. STORE EXPENSES (85 Rows)
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
(5, 'INVENTORY_RESTOCK', 19000.00, '2026-07-10'),

(4, 'RENT', 43000.00, '2026-07-07'),
(5, 'RENT', 47500.00, '2026-07-07'),

-- 2. Monthly Rent for Stores 6 through 20 (Varies by location prime real estate)
(6, 'RENT', 55000.00, '2026-07-07'),    -- Ekkamai BTS (Expensive)
(7, 'RENT', 41000.00, '2026-07-07'),    -- Ladprao Crossing
(8, 'RENT', 65000.00, '2026-07-07'),    -- Chatuchak Market (Massive footprint)
(9, 'RENT', 58000.00, '2026-07-07'),    -- Samyan Mitrtown
(10, 'RENT', 62000.00, '2026-07-07'),   -- Ari Station
(11, 'RENT', 45000.00, '2026-07-07'),   -- Huai Khwang
(12, 'RENT', 49000.00, '2026-07-07'),   -- Phaya Thai Link
(13, 'RENT', 46000.00, '2026-07-07'),   -- Ratchathewi
(14, 'RENT', 75000.00, '2026-07-07'),   -- MBK Center (Premium mall rent)
(15, 'RENT', 68000.00, '2026-07-07'),   -- Sathorn Thani (Business district)
(16, 'RENT', 38000.00, '2026-07-07'),   -- Khlong Toei
(17, 'RENT', 40000.00, '2026-07-07'),   -- Phra Khanong
(18, 'RENT', 50000.00, '2026-07-07'),   -- Bang Na Inter
(19, 'RENT', 42000.00, '2026-07-07'),   -- Ramkhamhaeng
(20, 'RENT', 53000.00, '2026-07-07'),   -- Bang Kapi Mall

-- 3. Monthly Utilities for Stores 6 through 20
(6, 'UTILITIES', 15200.00, '2026-07-08'),
(7, 'UTILITIES', 11500.00, '2026-07-08'),
(8, 'UTILITIES', 18400.00, '2026-07-08'),
(9, 'UTILITIES', 16000.00, '2026-07-08'),
(10, 'UTILITIES', 14500.00, '2026-07-08'),
(11, 'UTILITIES', 13200.00, '2026-07-08'),
(12, 'UTILITIES', 12800.00, '2026-07-08'),
(13, 'UTILITIES', 13000.00, '2026-07-08'),
(14, 'UTILITIES', 21000.00, '2026-07-08'),
(15, 'UTILITIES', 17500.00, '2026-07-08'),
(16, 'UTILITIES', 11000.00, '2026-07-08'),
(17, 'UTILITIES', 10500.00, '2026-07-08'),
(18, 'UTILITIES', 14200.00, '2026-07-08'),
(19, 'UTILITIES', 12100.00, '2026-07-08'),
(20, 'UTILITIES', 15000.00, '2026-07-08'),

-- 4. Payroll / Salaries for Stores 6 through 20 (Paying the new staff!)
(6, 'SALARIES', 36000.00, '2026-07-10'),
(7, 'SALARIES', 32000.00, '2026-07-10'),
(8, 'SALARIES', 40000.00, '2026-07-10'),
(9, 'SALARIES', 38000.00, '2026-07-10'),
(10, 'SALARIES', 35000.00, '2026-07-10'),
(11, 'SALARIES', 34000.00, '2026-07-10'),
(12, 'SALARIES', 33000.00, '2026-07-10'),
(13, 'SALARIES', 33500.00, '2026-07-10'),
(14, 'SALARIES', 45000.00, '2026-07-10'),
(15, 'SALARIES', 39000.00, '2026-07-10'),
(16, 'SALARIES', 31000.00, '2026-07-10'),
(17, 'SALARIES', 30500.00, '2026-07-10'),
(18, 'SALARIES', 35500.00, '2026-07-10'),
(19, 'SALARIES', 32500.00, '2026-07-10'),
(20, 'SALARIES', 36500.00, '2026-07-10'),

-- 5. Inventory Restock Costs for Stores 6 through 20 (Logging the new goods we just added)
(6, 'INVENTORY_RESTOCK', 24000.00, '2026-07-11'),
(7, 'INVENTORY_RESTOCK', 18500.00, '2026-07-11'),
(8, 'INVENTORY_RESTOCK', 35000.00, '2026-07-11'),
(9, 'INVENTORY_RESTOCK', 28000.00, '2026-07-11'),
(10, 'INVENTORY_RESTOCK', 22000.00, '2026-07-11'),
(11, 'INVENTORY_RESTOCK', 21500.00, '2026-07-11'),
(12, 'INVENTORY_RESTOCK', 19000.00, '2026-07-11'),
(13, 'INVENTORY_RESTOCK', 20500.00, '2026-07-11'),
(14, 'INVENTORY_RESTOCK', 42000.00, '2026-07-11'),
(15, 'INVENTORY_RESTOCK', 31000.00, '2026-07-11'),
(16, 'INVENTORY_RESTOCK', 17000.00, '2026-07-11'),
(17, 'INVENTORY_RESTOCK', 16500.00, '2026-07-11'),
(18, 'INVENTORY_RESTOCK', 23000.00, '2026-07-11'),
(19, 'INVENTORY_RESTOCK', 19500.00, '2026-07-11'),
(20, 'INVENTORY_RESTOCK', 25000.00, '2026-07-11'),

(8, 'MAINTENANCE', 4500.00, '2026-07-09'),    -- Refrigerator leak fix at Chatuchak
(11, 'MAINTENANCE', 1200.00, '2026-07-10'),   -- Automatic door sensor calibration
(14, 'MAINTENANCE', 3800.00, '2026-07-11');   -- Replace broken POS scanner at MBK Center

-- =========================================================================
-- 14. WORKER SHIFTS
-- =========================================================================
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
(19, 1, '2026-07-11 07:00:00+07', NULL, 'ACTIVE'),

-- Completed Morning Shifts from Today (Ended at 2:00 PM)
(4, 1, '2026-07-11 06:00:00+07', '2026-07-11 14:00:00+07', 'COMPLETED'),
(5, 2, '2026-07-11 06:00:00+07', '2026-07-11 14:00:00+07', 'COMPLETED'),
(6, 3, '2026-07-11 06:00:00+07', '2026-07-11 14:00:00+07', 'COMPLETED'),
(7, 4, '2026-07-11 06:00:00+07', '2026-07-11 14:00:00+07', 'COMPLETED'),
(8, 5, '2026-07-11 06:00:00+07', '2026-07-11 14:00:00+07', 'COMPLETED'),

-- Completed Manager Shifts from Today (Ended 15 minutes ago at 4:00 PM)
(1, 1, '2026-07-11 08:00:00+07', '2026-07-11 16:00:00+07', 'COMPLETED'),
(2, 2, '2026-07-11 08:00:00+07', '2026-07-11 16:00:00+07', 'COMPLETED'),
(3, 3, '2026-07-11 08:00:00+07', '2026-07-11 16:00:00+07', 'COMPLETED'),

-- ACTIVE Afternoon Shifts (Clocked in at 2:00 PM, currently on the floor)
(9, 1, '2026-07-11 14:00:00+07', NULL, 'ACTIVE'),
(10, 2, '2026-07-11 14:00:00+07', NULL, 'ACTIVE'),
(11, 3, '2026-07-11 14:00:00+07', NULL, 'ACTIVE'),
(12, 4, '2026-07-11 14:00:00+07', NULL, 'ACTIVE'),
(13, 5, '2026-07-11 14:00:00+07', NULL, 'ACTIVE'),

-- Historical Shifts from yesterday to fill out HR records
(1, 1, '2026-07-10 08:00:00+07', '2026-07-10 16:00:00+07', 'COMPLETED'),
(2, 2, '2026-07-10 08:00:00+07', '2026-07-10 16:00:00+07', 'COMPLETED'),
(5, 2, '2026-07-10 06:00:00+07', '2026-07-10 14:00:00+07', 'COMPLETED'),
(9, 1, '2026-07-10 14:00:00+07', '2026-07-10 22:00:00+07', 'COMPLETED'),
(10, 2, '2026-07-10 14:00:00+07', '2026-07-10 22:00:00+07', 'COMPLETED'),
(20, 1, '2026-07-10 22:00:00+07', '2026-07-11 06:00:00+07', 'COMPLETED'), -- Night security
(20, 2, '2026-07-10 22:00:00+07', '2026-07-11 06:00:00+07', 'COMPLETED'); -- Night security

COMMIT;