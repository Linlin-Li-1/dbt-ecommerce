-- {{ config(materialized='table') }}
-- {{ config(materialized='incremental') }}

-- select
--     order_id,
--     customer_id,
--     ordered_at,
--     store_id,
--     subtotal,
--     tax_paid,
--     order_total
-- from {{ ref('stg_orders') }}


{{ config(materialized='incremental') }}

select
    order_id,
    customer_id,
    ordered_at,
    store_id,
    subtotal,
    tax_paid,
    order_total
from {{ ref('stg_orders') }}

{% if is_incremental() %}

where ordered_at > (
    select max(ordered_at)
    from {{ this }}
)

{% endif %}