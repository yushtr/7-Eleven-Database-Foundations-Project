CREATE TRIGGER trg_update_stock
    AFTER INSERT
    ON transaction_items
    FOR EACH ROW
    EXECUTE PROCEDURE fn_update_stock();

CREATE TRIGGER trg_increase_stock_due_to_order_completion
    AFTER UPDATE OF order_status
    ON orders
    FOR EACH ROW 
    WHEN (NEW.order_status = 'COMPLETED')
    EXECUTE PROCEDURE fn_increase_stock_due_to_order_completion(); 

CREATE TRIGGER trg_stock_reorder
    AFTER UPDATE OF stock_quantity
    ON store_inventory
    FOR EACH ROW 
    WHEN (OLD.stock_quantity >= 10 AND NEW.stock_quantity < 10)
    EXECUTE PROCEDURE fn_stock_reorder(); 

CREATE TRIGGER trg_all_member_points
    AFTER INSERT 
    ON sales_transactions
    FOR EACH ROW 
    WHEN (NEW.member_id IS NOT NULL)
    EXECUTE PROCEDURE fn_all_member_points();
