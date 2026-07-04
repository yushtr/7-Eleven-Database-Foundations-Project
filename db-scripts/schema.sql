DROP TABLE IF EXISTS store_inventory CASCADE; 
DROP TABLE IF EXISTS suppliers CASCADE; 
DROP TABLE IF EXISTS deliveries CASCADE; 
DROP TABLE IF EXISTS delivery_items CASCADE; 
DROP TABLE IF EXISTS all_members CASCADE; 
DROP TABLE IF EXISTS sales_transactions CASCADE; 
DROP TABLE IF EXISTS transaction_items CASCADE; 
DROP TABLE IF EXISTS store_expenses CASCADE; 

CREATE TABLE store_inventory ( 
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    stock_quantity INT NOT NULL,
    expiration_date DATE NOT NULL,
        PRIMARY KEY (store_id, product_id, expiration_date),
        CONSTRAINT fk_store_inventory_store_id
            FOREIGN KEY(store_id)
            REFERENCES branches(store_id),
        CONSTRAINT fk_store_inventory_product_id
            FOREIGN KEY(product_id)
            REFERENCES products(product_id)  
);

CREATE TABLE suppliers (
    supplier_id SERIAL NOT NULL, 
    company_name VARCHAR NOT NULL,
    contact_name VARCHAR NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
        PRIMARY KEY (supplier_id)
);

CREATE TABLE deliveries ( 
    delivery_id SERIAL NOT NULL, 
    store_id INT NOT NULL, 
    supplier_id INT NOT NULL, 
    delivery_date TIMESTAMPTZ NOT NULL,
    driver_name VARCHAR NOT NULL, 
    driver_phone VARCHAR NOT NULL,
    license_plate VARCHAR NOT NULL,
        PRIMARY KEY (delivery_id)
);

CREATE TABLE delivery_items (
    delivery_id INT NOT NULL, 
    product_id INT NOT NULL, 
    quantity_delivered INT NOT NULL, 
    expiration_date DATE NOT NULL,
        PRIMARY KEY (delivery_id, product_id, expiration_date),
        CONSTRAINT fk_delivery_items_delivery_id
            FOREIGN KEY(delivery_id)
            REFERENCES deliveries(delivery_id),
        CONSTRAINT fk_delivery_items_product_id
            FOREIGN KEY(product_id)
            REFERENCES products(product_id)
);

CREATE TABLE all_members (
    member_id SERIAL NOT NULL, 
    phone_number VARCHAR(20) NOT NULL,
    points_balance INT NOT NULL,
        PRIMARY KEY (member_id)
); 

CREATE TABLE sales_transactions ( 
    transaction_id SERIAL, 
    store_id INT NOT NULL, 
    member_id INT, --allows null--
    employee_id INT NOT NULL, 
    total_amount DECIMAL(10, 2) NOT NULL, 
    transaction_date TIMESTAMPTZ NOT NULL, 
    payment_method VARCHAR(50) NOT NULL, 
        PRIMARY KEY (transaction_id), 
        CONSTRAINT fk_sales_transactions_store_id
            FOREIGN KEY(store_id) 
            REFERENCES branches(store_id), 
        CONSTRAINT fk_sales_transactions_member_id
            FOREIGN KEY(member_id)
            REFERENCES all_members(member_id)
);

CREATE TABLE transaction_items (
    transaction_id INT NOT NULL, 
    product_id INT NOT NULL, 
    expiration_date DATE NOT NULL,
    quantity INT NOT NULL, 
    unit_price DECIMAL(5, 2) NOT NULL, 
        PRIMARY KEY (transaction_id, product_id, expiration_date), 
        CONSTRAINT fk_transaction_items_transaction_id 
            FOREIGN KEY(transaction_id)
            REFERENCES sales_transactions(transaction_id), 
        CONSTRAINT fk_transaction_items_product_id
            FOREIGN KEY(product_id)
            REFERENCES products(product_id)
);

CREATE TABLE store_expenses ( 
    expense_id SERIAL NOT NULL,
    store_id INT NOT NULL, 
    expense_type VARCHAR NOT NULL, 
    amount DECIMAL(15,2) NOT NULL, 
    expense_date DATE NOT NULL,
        PRIMARY KEY (expense_id),
        CONSTRAINT fk_store_expenses_store_id
            FOREIGN KEY(store_id)
            REFERENCES branches(store_id)
);

