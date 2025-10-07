{# int_customers_first_order.sql #}

with int_orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
),

agg as (

    select

        customer_id,
        min(order_datetime) as first_order_datetime,
        max(order_datetime) as last_order_datetime,
        count(distinct order_id) as total_orders,
        sum(net_amount) as total_spent_eur,
        sum(net_amount) / count(distinct order_id) as avg_order_value_eur

    from int_orders_enriched
    group by customer_id
)

select * from agg
