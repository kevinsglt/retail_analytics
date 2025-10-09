{# mart_sales_daily_product_agg.sql #}

with dim_date as (
    select * from {{ ref('dim_date') }}
),

int_order_lines_enriched as (
    select * from {{ ref('int_order_lines_enriched') }}
),

agg as (

    select

        d.calendar_date,
        ol.product_id,
        ol.product_display_name,
        ol.collection,
        ol.category,
        count(distinct ol.order_id) as order_with_product_cnt, {# Dans combien de commande se retrouve le produit / jour (une granularité) #}
        sum(ol.quantity) as units_sold,
        sum(ol.order_line_net_amount) as net_sales_eur,
        sum(ol.order_line_net_amount - ol.cost) as margin_eur

    from dim_date as d
    left join int_order_lines_enriched as ol
        on d.calendar_date = cast(ol.order_datetime as date)
    where
        cast(d.calendar_date as date) >= '2025-01-01'
    {# Premiers enregistrements #}
    group by
        d.calendar_date, ol.product_id, ol.product_display_name,
        ol.collection, ol.category

)

select * from agg
