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



