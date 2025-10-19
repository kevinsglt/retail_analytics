{# int_customers_orders_summary.sql #}

with int_orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
),

int_order_lines_enriched as (
    select * from {{ ref('int_order_lines_enriched') }}
),

agg as (

    select

        oe.customer_id,
        min(oe.order_datetime) as first_order_datetime,
        max(oe.order_datetime) as last_order_datetime,
        count(distinct oe.order_id) as total_orders,
        sum(ol.quantity) as total_units,
        sum(oe.net_amount) as total_spent_eur,
        sum(oe.net_amount) / count(distinct oe.order_id) as avg_order_value_eur,
        round(sum(ol.quantity) / count(distinct oe.order_id), 0) as avg_unit_per_order

    from int_orders_enriched as oe
    left join int_order_lines_enriched as ol
        on oe.order_id = ol.order_id
    group by oe.customer_id
)

select * from agg
