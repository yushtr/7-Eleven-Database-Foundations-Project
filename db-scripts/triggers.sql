CREATE TRIGGER trg_update_stock
    AFTER INSERT
    ON transaction_items
    FOR EACH ROW
    EXECUTE PROCEDURE fn_update_stock();