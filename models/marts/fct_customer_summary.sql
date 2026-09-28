select
    customer_id,
    order_count,
    total_revenue
from {{ ref('int_customer_orders') }}

-- select
--     customer_id,
--     order_count,
--     total_revenue
-- from {{ ref('int_customer_orders') }}

-- union all

-- select
--     null as customer_id,
--     1 as order_count,
--     100 as total_revenue