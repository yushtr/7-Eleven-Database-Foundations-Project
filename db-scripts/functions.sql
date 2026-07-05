CREATE OR REPLACE FUNCTION fn_get_branch_revenue(target_store_id INT, start_date DATE, end_date DATE) 
RETURNS DECIMAL(15,2) AS 
$$ 
SELECT COALESCE(SUM(total_amount), 0.00) AS revenue
FROM sales_transactions
WHERE store_id = $1 
    AND transaction_date BETWEEN $2 AND $3
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_get_branch_expenses(target_store_id INT, start_date DATE, end_date DATE)
RETURNS DECIMAL(15,2) AS 
$$ 
SELECT COALESCE(SUM(amount), 0.00) AS expense
FROM store_expenses
WHERE store_id = $1 
    AND expense_date BETWEEN $2 AND $3
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION fn_get_branch_profits(target_store_id INT, start_date DATE, end_date DATE) 
RETURNS DECIMAL(15,2) AS 
$$ 
SELECT fn_get_branch_revenue($1, $2, $3) - fn_get_branch_expenses($1, $2, $3)
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION fn_check_expired_products(target_store_id INT, current_date DATE) 
RETURNS SETOF store_inventory AS 
$$
SELECT product_id, stock_quantity
FROM store_inventory
WHERE store_id = $1
    AND DATE = $2
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION fn_check_expired_products_relation_display(target_store_id INT, current_date DATE)
RETURNS SETOF store_inventory AS 
$$
SELECT (fn_check_expired_products($1, $2)).*
$$ LANGUAGE SQL;
