DROP FUNCTION IF EXISTS fn_price_audit(); 
DROP FUNCTION IF EXISTS fn_deleted_product_audit(); 
DROP FUNCTION IF EXISTS fn_expenses_audit(); 
DROP FUNCTION IF EXISTS fn_transaction_audit(); 

CREATE OR REPLACE FUNCTION fn_price_audit()
RETURNS TRIGGER AS
$$ 
BEGIN 
    INSERT INTO price_history_audit (product_id, old_price, new_price, changed_by) VALUES(NEW.product_id, OLD.price, NEW.price, current_user);
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_deleted_product_audit()
RETURNS TRIGGER AS 
$$ 
BEGIN 
    INSERT INTO deleted_products_audit (old_product_id, changed_by) VALUES(OLD.product_id, current_user); 
    RETURN OLD; 
END; 
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION fn_expenses_audit()
RETURNS TRIGGER AS 
$$ 
BEGIN 
    INSERT INTO expenses_audit (expense_id, old_amount, new_amount, changed_by) VALUES(NEW.expense_id, OLD.amount, NEW.amount, current_user);
    RETURN NEW; 
END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_transaction_audit()
RETURNS TRIGGER AS 
$$ 
BEGIN
    INSERT INTO transaction_audit (transaction_id, old_total_amount, new_total_amount, changed_by) VALUES(NEW.transaction_id, OLD.total_amount, NEW.total_amount, current_user);
    RETURN NEW; 
END; 
$$ LANGUAGE plpgsql;