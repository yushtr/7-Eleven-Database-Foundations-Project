CREATE TRIGGER trg_price_audit
    AFTER UPDATE OF price
    ON products 
    FOR EACH ROW 
    EXECUTE PROCEDURE fn_price_audit(); 

CREATE TRIGGER trg_deleted_product_audit
    AFTER DELETE
    ON products
    FOR EACH ROW 
    EXECUTE PROCEDURE fn_deleted_product_audit(); 

CREATE TRIGGER trg_expenses_audit
    AFTER UPDATE OF amount
    ON store_expenses
    FOR EACH ROW 
    EXECUTE PROCEDURE fn_expenses_audit(); 

CREATE TRIGGER trg_transaction_audit
    AFTER UPDATE OF total_amount 
    ON sales_transactions 
    FOR EACH ROW 
    EXECUTE PROCEDURE fn_transaction_audit(); 