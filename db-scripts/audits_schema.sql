DROP TABLE IF EXISTS price_history_audit CASCADE; 
DROP TABLE IF EXISTS deleted_products_audit CASCADE;

CREATE TABLE price_history_audit ( 
    audit_id SERIAL NOT NULL, 
    product_id INT NOT NULL, 
    old_price DECIMAL NOT NULL, 
    new_price DECIMAL NOT NULL, 
    changed_by TEXT NOT NULL,
    change_time TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    change_date DATE NOT NULL DEFAULT CURRENT_DATE, 
        PRIMARY KEY (audit_id)
);

CREATE TABLE deleted_products_audit ( 
    audit_id SERIAL NOT NULL, 
    old_product_id INT NOT NULL, 
    changed_by TEXT, 
    change_time TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    change_date DATE NOT NULL DEFAULT CURRENT_DATE,
        PRIMARY KEY (audit_id)
);

CREATE TABLE expenses_audit ( 
    audit_id SERIAL NOT NULL, 
    expense_id INT NOT NULL, 
    old_amount DECIMAL NOT NULL, 
    new_amount DECIMAL NOT NULL, 
    changed_by TEXT NOT NULL, 
    change_time TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    change_date DATE NOT NULL DEFAULT CURRENT_DATE, 
        PRIMARY KEY (audit_id)
);

CREATE TABLE transaction_audit ( 
    audit_id SERIAL NOT NULL, 
    transaction_id INT NOT NULL, 
    old_total_amount DECIMAL NOT NULL, 
    new_total_amount DECIMAL NOT NULL, 
    changed_by TEXT NOT NULL, 
    change_time TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    change_date DATE NOT NULL DEFAULT CURRENT_DATE, 
        PRIMARY KEY (audit_id)
);