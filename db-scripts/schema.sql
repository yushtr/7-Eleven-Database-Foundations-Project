DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS store_inventory CASCADE; 
DROP TABLE IF EXISTS suppliers CASCADE; 
DROP TABLE IF EXISTS deliveries CASCADE; 
DROP TABLE IF EXISTS delivery_items CASCADE; 
DROP TABLE IF EXISTS all_members CASCADE; 
DROP TABLE IF EXISTS sales_transactions CASCADE; 
DROP TABLE IF EXISTS transaction_items CASCADE; 
DROP TABLE IF EXISTS store_expenses CASCADE; 
DROP TABLE IF EXISTS branches CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS worker_shifts CASCADE;

CREATE TABLE branches ( 
    store_id SERIAL NOT NULL, 
    branch_name VARCHAR NOT NULL, 
    address VARCHAR NOT NULL,
        PRIMARY KEY (store_id),
        CONSTRAINT uq_branch_name UNIQUE (branch_name),
        CONSTRAINT chk_branch_name_not_empty CHECK (length(btrim(branch_name)) > 0),
        CONSTRAINT chk_address_name_not_empty CHECK (length(btrim(address)) > 0)
);

CREATE TABLE categories ( 
    category_id SERIAL NOT NULL, 
    category_name VARCHAR NOT NULL, 
    subcategory_name VARCHAR NOT NULL,
        PRIMARY KEY (category_id),
        CONSTRAINT chk_category_name_not_empty CHECK (length(btrim(category_name)) > 0),
        CONSTRAINT chk_subcategory_name_not_empty CHECK (length(btrim(subcategory_name)) > 0),
        CONSTRAINT uq_category_subcategory UNIQUE (category_name, subcategory_name)
);

CREATE TABLE products ( 
    product_id SERIAL NOT NULL,
    category_id INT NOT NULL, 
    product_name VARCHAR NOT NULL, 
    price DECIMAL(10, 2) NOT NULL,
        PRIMARY KEY (product_id),
        CONSTRAINT fk_products_category_id 
            FOREIGN KEY(category_id)
            REFERENCES categories(category_id),
        CONSTRAINT chk_product_name_not_empty CHECK (length(btrim(product_name)) > 0),
        CONSTRAINT chk_positive_price CHECK (price > 0)
);

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
            REFERENCES products(product_id),
        CONSTRAINT chk_positive_stock_quantity CHECK (stock_quantity >= 0), 
        CONSTRAINT chk_future_expiration_date CHECK (expiration_date >= CURRENT_DATE)
);

CREATE TABLE suppliers (
    supplier_id SERIAL NOT NULL, 
    company_name VARCHAR NOT NULL,
    contact_name VARCHAR NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
        PRIMARY KEY (supplier_id),
        CONSTRAINT chk_company_name_not_empty CHECK (length(btrim(company_name)) > 0),
        CONSTRAINT chk_contact_name_not_empty CHECK (length(btrim(contact_name)) > 0), 
        CONSTRAINT chk_phone_number_not_empty CHECK (length(btrim(phone_number)) > 0),
        CONSTRAINT chk_valid_phone_format CHECK (phone_number ~ '^\+?[0-9\s\-]+$')
);

CREATE TABLE orders (
    order_id SERIAL NOT NULL, 
    store_id INT NOT NULL, 
    product_id INT NOT NULL, 
    order_date DATE NOT NULL DEFAULT CURRENT_DATE, 
    quantity INT NOT NULL DEFAULT 100,
    order_status VARCHAR(15) NOT NULL,
        PRIMARY KEY (order_id), 
        CONSTRAINT fk_orders_store_id
            FOREIGN KEY(store_id)
            REFERENCES branches(store_id), 
        CONSTRAINT fk_orders_product_id
            FOREIGN KEY(product_id)
            REFERENCES products(product_id),
        CONSTRAINT chk_valid_quantity CHECK (quantity > 0),
        CONSTRAINT chk_valid_order_status CHECK (order_status IN ('ORDER SENT', 'IN PROCESS', 'COMPLETED'))
);

CREATE TABLE deliveries ( 
    delivery_id SERIAL NOT NULL, 
    store_id INT NOT NULL, 
    supplier_id INT NOT NULL, 
    delivery_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    driver_name VARCHAR NOT NULL, 
    driver_phone VARCHAR NOT NULL,
    license_plate VARCHAR NOT NULL,
        PRIMARY KEY (delivery_id), 
        CONSTRAINT fk_deliveries_store_id
            FOREIGN KEY(store_id)
            REFERENCES branches(store_id), 
        CONSTRAINT fk_deliveries_supplier_id
            FOREIGN KEY(supplier_id)
            REFERENCES suppliers(supplier_id),
        CONSTRAINT chk_driver_name_not_empty CHECK (length(btrim(driver_name)) > 0), 
        CONSTRAINT chk_driver_phone_not_empty CHECK (length(btrim(driver_phone)) > 0),
        CONSTRAINT chk_license_plate_not_empty CHECK (length(btrim(license_plate)) > 0), 
        CONSTRAINT chk_valid_driver_phone CHECK (driver_phone ~ '^\+?[0-9\s\-]+$')
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
            REFERENCES products(product_id),
        CONSTRAINT chk_positive_delivery_quantity CHECK (quantity_delivered > 0),
        CONSTRAINT chk_future_expiration_date CHECK (expiration_date > CURRENT_DATE)
);

CREATE TABLE all_members (
    member_id SERIAL NOT NULL, 
    phone_number VARCHAR(20) NOT NULL,
    points_balance INT NOT NULL,
        PRIMARY KEY (member_id),
        CONSTRAINT chk_phone_number_not_empty CHECK (length(btrim(phone_number)) > 0),
        CONSTRAINT chk_valid_phone_format CHECK (phone_number ~ '^\+?[0-9\s\-]+$'),
        CONSTRAINT chk_positive_points_balance CHECK (points_balance >= 0)
); 

CREATE TABLE employees (
    employee_id SERIAL NOT NULL, 
    store_id INT NOT NULL, 
    employee_name VARCHAR NOT NULL, 
    role_type VARCHAR NOT NULL, 
        PRIMARY KEY (employee_id), 
        CONSTRAINT fk_employees_store_id
            FOREIGN KEY(store_id)
            REFERENCES branches(store_id),
        CONSTRAINT chk_employee_name_not_empty CHECK (length(btrim(employee_name)) > 0),
        CONSTRAINT chk_valid_role_type CHECK (role_type IN ('CASHIER', 'RESTOCKER', 'JANITOR', 'SECURITY', 'MANAGER'))
);

CREATE TABLE sales_transactions ( 
    transaction_id SERIAL, 
    store_id INT NOT NULL, 
    member_id INT, --allows null--
    phone_number VARCHAR, --allows null--
    employee_id INT NOT NULL, 
    total_amount DECIMAL(10, 2) NOT NULL, 
    transaction_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    payment_method VARCHAR(50) NOT NULL, 
        PRIMARY KEY (transaction_id), 
        CONSTRAINT fk_sales_transactions_store_id
            FOREIGN KEY(store_id) 
            REFERENCES branches(store_id), 
        CONSTRAINT fk_sales_transactions_member_id
            FOREIGN KEY(member_id)
            REFERENCES all_members(member_id),
        CONSTRAINT fk_sales_transactions_employee_id
            FOREIGN KEY(employee_id)
            REFERENCES employees(employee_id),
        CONSTRAINT chk_positive_total_amount CHECK (total_amount >= 0),
        CONSTRAINT chk_valid_payment_method CHECK (payment_method IN ('CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'TRUE_MONEY', 'SCAN')),
        CONSTRAINT chk_valid_phone_format CHECK (phone_number IS NULL OR phone_number ~ '^\+?[0-9\s\-]+$')
);

CREATE TABLE transaction_items (
    transaction_id INT NOT NULL, 
    product_id INT NOT NULL, 
    expiration_date DATE NOT NULL,
    quantity INT NOT NULL, 
    unit_price DECIMAL(10, 2) NOT NULL, 
        PRIMARY KEY (transaction_id, product_id, expiration_date), 
        CONSTRAINT fk_transaction_items_transaction_id 
            FOREIGN KEY(transaction_id)
            REFERENCES sales_transactions(transaction_id), 
        CONSTRAINT fk_transaction_items_product_id
            FOREIGN KEY(product_id)
            REFERENCES products(product_id),
        CONSTRAINT chk_positive_quantity CHECK (quantity > 0),
        CONSTRAINT chk_positive_unit_price CHECK (unit_price > 0)
);

CREATE TABLE store_expenses ( 
    expense_id SERIAL NOT NULL,
    store_id INT NOT NULL, 
    expense_type VARCHAR NOT NULL, 
    amount DECIMAL(15,2) NOT NULL, 
    expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
        PRIMARY KEY (expense_id),
        CONSTRAINT fk_store_expenses_store_id
            FOREIGN KEY(store_id)
            REFERENCES branches(store_id),
        CONSTRAINT chk_expense_type_not_empty CHECK (length(btrim(expense_type)) > 0),
        CONSTRAINT chk_valid_expense_type CHECK (expense_type IN ('RENT', 'UTILITIES', 'SALARIES', 'INVENTORY_RESTOCK', 'MAINTENANCE', 'MARKETING', 'MISCELLANEOUS')),
        CONSTRAINT chk_positive_amount CHECK (amount > 0)
);

CREATE TABLE worker_shifts (
    shift_id SERIAL NOT NULL, 
    employee_id INT NOT NULL, 
    store_id INT NOT NULL, 
    clock_in TIMESTAMPTZ NOT NULL, 
    clock_out TIMESTAMPTZ NOT NULL, 
    shift_status VARCHAR NOT NULL, 
        PRIMARY KEY (shift_id), 
        CONSTRAINT fk_worker_shifts_employee_id
            FOREIGN KEY(employee_id)
            REFERENCES employees(employee_id), 
        CONSTRAINT fk_worker_shifts_store_id
            FOREIGN KEY(store_id)
            REFERENCES branches(store_id),
        CONSTRAINT chk_valid_shift_timeline CHECK (clock_out >= clock_in),
        CONSTRAINT chk_valid_shift_status CHECK (shift_status IN ('SCHEDULED', 'ACTIVE', 'COMPLETED', 'ABSENT', 'CANCELED'))
);

