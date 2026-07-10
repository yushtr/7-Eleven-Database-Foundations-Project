-- the core :

CREATE OR REPLACE FUNCTION fn_search_available_products(target_store_id INT, keyword TEXT)
RETURNS TABLE (
    product_id INT,
    product_name VARCHAR,
    stock_quantity INT,
    price DECIMAL
) AS
$$
SELECT
    s.product_id,
    p.product_name,
    s.stock_quantity,
    p.price
FROM store_inventory AS s
JOIN products AS p ON s.product_id = p.product_id
WHERE s.store_id = $1
    AND s.stock_quantity > 0
    AND LOWER(p.product_name) LIKE LOWER('%' || $2 || '%');
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_get_branch_inventory_value(target_store_id INT)
RETURNS DECIMAL(15,2) AS
$$
SELECT COALESCE(SUM(s.stock_quantity * p.price), 0.00)
FROM store_inventory AS s
JOIN products AS p ON s.product_id = p.product_id
WHERE s.store_id = $1;
$$ LANGUAGE SQL;

-- inventory and supplier logistics :

CREATE OR REPLACE FUNCTION fn_get_branch_revenue(target_store_id INT, start_date DATE, end_date DATE) 
RETURNS DECIMAL(15,2) AS 
$$ 
SELECT COALESCE(SUM(st.total_amount), 0.00) AS revenue
FROM sales_transactions AS st
WHERE st.store_id = $1 
    AND st.transaction_date BETWEEN $2 AND $3;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_get_branch_expenses(target_store_id INT, start_date DATE, end_date DATE)
RETURNS DECIMAL(15,2) AS 
$$ 
SELECT COALESCE(SUM(se.amount), 0.00) AS expense
FROM store_expenses AS se
WHERE se.store_id = $1 
    AND se.expense_date BETWEEN $2 AND $3;
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION fn_get_branch_profits(target_store_id INT, start_date DATE, end_date DATE) 
RETURNS DECIMAL(15,2) AS 
$$ 
SELECT COALESCE(fn_get_branch_revenue($1, $2, $3), 0.00) 
     - COALESCE(fn_get_branch_expenses($1, $2, $3), 0.00);
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION fn_check_expired_products(target_store_id INT) 
RETURNS SETOF store_inventory AS 
$$
SELECT si.*
FROM store_inventory AS si
WHERE si.store_id = $1
    AND si.expiration_date <= CURRENT_DATE
    AND si.stock_quantity > 0;
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION fn_update_stock()
RETURNS TRIGGER AS 
$$ 
BEGIN 
    UPDATE store_inventory
    SET stock_quantity = store_inventory.stock_quantity - NEW.quantity
    WHERE store_inventory.product_id = NEW.product_id
        AND store_inventory.store_id = NEW.store_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_increase_stock_due_to_order_completion()
RETURNS TRIGGER AS
$$ 
BEGIN 
    UPDATE store_inventory
    SET stock_quantity = store_inventory.stock_quantity + NEW.quantity
    WHERE store_inventory.product_id = NEW.product_id
        AND store_inventory.store_id = NEW.store_id;

    RETURN NEW;
END; 
$$ LANGUAGE plpgsql;  

CREATE OR REPLACE FUNCTION fn_stock_reorder()
RETURNS TRIGGER AS 
$$
BEGIN 
    INSERT INTO orders (store_id, product_id, quantity, order_status)
    VALUES (NEW.store_id, NEW.product_id, 100, 'ORDER SENT');

    RETURN NEW; 
END;
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION fn_all_member_points()
RETURNS TRIGGER AS 
$$
BEGIN 
    UPDATE all_members
    SET points_balance = FLOOR(NEW.total_amount/25) + points_balance
    WHERE member_id = NEW.member_id
        AND phone_number = NEW.phone_number;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- workforce management : 

CREATE OR REPLACE FUNCTION fn_get_employee_schedule(target_employee_id INT)
RETURNS SETOF worker_shifts AS
$$
SELECT ws.*
FROM worker_shifts AS ws
WHERE ws.employee_id = $1
ORDER BY ws.clock_in DESC;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_get_active_staff(target_store_id INT)
RETURNS TABLE (
    employee_name VARCHAR,
    role_type VARCHAR,
    clock_in TIMESTAMPTZ
) AS
$$
SELECT 
    e.employee_name,
    e.role_type,
    ws.clock_in
FROM employees AS e
JOIN worker_shifts AS ws ON e.employee_id = ws.employee_id
WHERE e.store_id = $1
    AND ws.clock_in IS NOT NULL
    AND ws.clock_out IS NULL;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_get_shift_hours(target_employee_id INT, start_date DATE, end_date DATE)
RETURNS DECIMAL(10,2) AS
$$
SELECT COALESCE(
    SUM(EXTRACT(EPOCH FROM (ws.clock_out - ws.clock_in)) / 3600),
    0.00
)
FROM worker_shifts AS ws
WHERE ws.employee_id = $1
    AND DATE(ws.clock_in) BETWEEN $2 AND $3
    AND ws.clock_out IS NOT NULL;
$$ LANGUAGE SQL;