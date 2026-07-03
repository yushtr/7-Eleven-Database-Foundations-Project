DROP TABLE IF EXISTS store_inventory CASCADE; 
DROP TABLE IF EXISTS suppliers CASCADE; 
DROP TABLE IF EXISTS deliveries CASCADE; 
DROP TABLE IF EXISTS delivery_items CASCADE; 
DROP TABLE IF EXISTS all_members CASCADE; 
DROP TABLE IF EXISTS sales_transactions CASCADE; 
DROP TABLE IF EXISTS transaction_items CASCADE; 
DROP TABLE IF EXISTS store_expenses CASCADE; 

CREATE TABLE store_inventory ( 
    store_id INT,
    product_id INT,
    stock_quantity INT,
    expiration_date DATE,
        PRIMARY KEY (store_id, product_id, expiration_date),
        CONSTRAINT fk_store_inventory_store_id
            FOREIGN KEY(store_id)
            REFERENCES branches(store_id),
        CONSTRAINT fk_store_inventory_product_id
            FOREIGN KEY(product_id)
            REFERENCES products(product_id)  
);

CREATE TABLE suppliers (
    supplier_id SERIAL, 
    company_name VARCHAR,
    contact_name VARCHAR,
    phone_number VARCHAR(20),
        PRIMARY KEY (supplier_id)
);

CREATE TABLE deliveries ( 
    delivery_id SERIAL, 
    store_id INT, 
    supplier_id INT, 
    delivery_date TIMESTAMPTZ,
    driver_name VARCHAR, 
    driver_phone VARCHAR,
    license_plate VARCHAR,
        PRIMARY KEY (delivery_id)
);

CREATE TABLE delivery_items (
    delivery_id INT, 
    product_id INT, 
    quantity_delivered INT, 
    expiration_date DATE,
        PRIMARY KEY (delivery_id, product_id, expiration_date),
        CONSTRAINT fk_delivery_items_delivery_id
            FOREIGN KEY(delivery_id)
            REFERENCES deliveries(delivery_id),
        CONSTRAINT fk_delivery_items_product_id
            FOREIGN KEY(product_id)
            REFERENCES products(product_id)
);
