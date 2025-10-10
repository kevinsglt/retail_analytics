{# mart_product_360.sql #}

with int_order_lines_enriched as (
    select * from {{ ref('int_order_lines_enriched') }}
),

int_orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
),

final as (

    select

        ol.product_id,
        ol.product_display_name,
        ol.collection,
        ol.category,
        sum(ol.quantity) as quantity_sold,
        count(distinct ol.order_id) as total_orders_with_product,
        count(distinct o.customer_id) as total_customers_reached,
        round(cast(sum(ol.order_line_net_amount) as int), 2) as total_sales_amount,
        case
            when min(cast(ol.order_datetime as date)) >= current_date - interval '30 days' then 'New product'
            when max(cast(ol.order_datetime as date)) >= current_date - interval '90 days' then 'Active product'
            when max(cast(ol.order_datetime as date)) >= current_date - interval '180 days' then 'Declined product'
            else 'Discontinued'
        end as product_lifecycle_stage

    from int_order_lines_enriched as ol

    left join int_orders_enriched as o
        on ol.order_id = o.order_id

    group by
        ol.product_id, ol.product_display_name,
        ol.collection, ol.category

)

select * from final
