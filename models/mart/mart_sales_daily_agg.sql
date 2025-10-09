{# mart_sales_daily_agg.sql #}

with dim_date as (
    select * from {{ ref('dim_date') }}
),

int_orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
),

agg as (

    select

        d.calendar_date,
        o.store_id,
        o.channel,
        count(distinct o.customer_id) as total_customers,
        count(distinct o.order_id) as total_orders,
        sum(o.net_amount) as revenue_eur,
        round(cast(sum(o.net_amount) / count(distinct o.customer_id) as int), 2) as aov_eur

    from dim_date as d
    left join int_orders_enriched as o
        on d.calendar_date = cast(o.order_datetime as date)
    group by d.calendar_date, o.store_id, o.channel

)

select * from agg
