CREATE ROLE pos_cashier_role;
CREATE ROLE store_manager_role;
CREATE ROLE corporate_admin_role;

GRANT SELECT ON inventory_stock_view, cashier_sales_view TO pos_cashier_role;

GRANT INSERT ON sales_transactions, transaction_items TO pos_cashier_role;
GRANT UPDATE (points_balance) ON all_members TO pos_cashier_role; 

GRANT pos_cashier_role TO store_manager_role;

GRANT SELECT ON 
    incoming_deliveries_view,
    manager_inventory_alerts,
    manager_daily_financials,
    manager_daily_expenses,
    manager_daily_net_profit,
    branch_product_summary_view,
    member_purchase_summary_view,
    employee_shift_summary_view,
    active_staff_view,
    branch_staff_summary_view
TO store_manager_role;

GRANT INSERT, UPDATE ON store_inventory, orders, deliveries, delivery_items TO store_manager_role;
GRANT INSERT, UPDATE ON employees, worker_shifts TO store_manager_role;
GRANT INSERT ON store_expenses TO store_manager_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO corporate_admin_role;
GRANT SELECT ON ALL VIEWS IN SCHEMA public TO corporate_admin_role;

CREATE USER BKK_REGISTER_01 WITH LOGIN PASSWORD 'pos_terminal_secure_pass_2026';
CREATE USER branch_manager_01 WITH LOGIN PASSWORD 'manager_auth_secure_pass_2026';
GRANT pos_cashier_role TO BKK_REGISTER_01;
GRANT store_manager_role TO branch_manager_01;