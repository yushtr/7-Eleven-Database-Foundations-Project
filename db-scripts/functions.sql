CREATE OR REPLACE FUNCTION fn_get_branch_revenue(target_store_id INT, start_date DATE, end_date DATE) 
RETURNS DECIMAL(15,2) AS 
$$ 
SELECT COALESCE(SUM(total_amount), 0.00) AS revenue
FROM sales_transactions
WHERE store_id = $1 
    AND transaction_date BETWEEN $2 AND $3
$$ LANGUAGE SQL;