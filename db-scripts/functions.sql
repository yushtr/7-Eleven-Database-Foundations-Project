-- the core :

CREATE OR REPLACE FUNCTION fn_search_products(keyword TEXT)
RETURNS SETOF products AS
$$
SELECT *
FROM products
WHERE LOWER(product_name) LIKE LOWER('%' || $1 || '%');
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_get_branch_inventory_value(target_store_id INT)
RETURNS DECIMAL(15,2) AS
$$
SELECT COALESCE(SUM(stock_quantity * price), 0.00)
FROM store_inventory
JOIN products USING (product_id)
WHERE store_id = $1;
$$ LANGUAGE SQL;

-- inventory and supplier logistics :

CREATE OR REPLACE FUNCTION fn_get_branch_revenue(target_store_id INT, start_date DATE, end_date DATE) 
RETURNS DECIMAL(15,2) AS 
$$ 
SELECT COALESCE(SUM(total_amount), 0.00) AS revenue
FROM sales_transactions
WHERE store_id = $1 
    AND transaction_date BETWEEN $2 AND $3;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_get_branch_expenses(target_store_id INT, start_date DATE, end_date DATE)
RETURNS DECIMAL(15,2) AS 
$$ 
SELECT COALESCE(SUM(amount), 0.00) AS expense
FROM store_expenses
WHERE store_id = $1 
    AND expense_date BETWEEN $2 AND $3;
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION fn_get_branch_profits(target_store_id INT, start_date DATE, end_date DATE) 
RETURNS DECIMAL(15,2) AS 
$$ 
SELECT COALESCE(fn_get_branch_revenue($1, $2, $3), 0.00) - COALESCE(fn_get_branch_expenses($1, $2, $3), 0.00);
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION fn_check_expired_products(target_store_id INT) 
RETURNS SETOF store_inventory AS 
$$
SELECT *
FROM store_inventory
WHERE store_id = $1
    AND expiration_date <= CURRENT_DATE
    AND stock_quantity > 0;
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION fn_update_stock(product_id INT, quantity_sold INT) 
RETURNS INT AS 
$$ 
DECLARE 
    new_stock INT; 
BEGIN 
    UPDATE store_inventory
    SET stock_quantity = stock_quantity - $2
    WHERE product_id = $1
    RETURNING stock_quantity INTO new_stock;

    RETURN new_stock; 
END;
$$ LANGUAGE plpgsql; 

-- workforce management : 

CREATE OR REPLACE FUNCTION fn_get_employee_schedule(target_employee_id INT)
RETURNS SETOF worker_shifts AS
$$
SELECT *
FROM worker_shifts
WHERE employee_id = $1
ORDER BY clock_in DESC;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_get_active_staff(target_store_id INT)
RETURNS TABLE (
    employee_name VARCHAR,
    role_type VARCHAR,
    clock_in TIMESTAMPTZ
) AS
$$
SELECT employee_name, role_type, clock_in
FROM employees
JOIN worker_shifts USING (employee_id)
WHERE store_id = $1
    AND clock_in IS NOT NULL
    AND clock_out IS NULL;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_get_shift_hours(target_employee_id INT, start_date DATE, end_date DATE)
RETURNS DECIMAL(10,2) AS
$$
SELECT COALESCE(
    SUM(EXTRACT(EPOCH FROM (clock_out - clock_in)) / 3600),
    0.00
)
FROM worker_shifts
WHERE employee_id = $1
    AND DATE(clock_in) BETWEEN $2 AND $3
    AND clock_out IS NOT NULL;
$$ LANGUAGE SQL;