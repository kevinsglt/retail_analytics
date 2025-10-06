{# int_order_lines_enriched.sql #}

with stg_order_lines as (
    select * from {{ ref('stg_order_lines') }}
),

int_orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
),

stg_products as (
    select * from {{ ref('stg_products') }}
),

joined as (

    select

        ol.order_line_id,

        ol.order_id,
        ol.product_id,
        p.product_display_name,
        p.price,
        ol.quantity,
        (p.price * ol.quantity) as order_line_net_amount,
        p.collection,
        p.category,

        o.order_date,
        o.order_status,
        o.net_amount as total_order_net_amount,
        o.payment_method,
        o.store_id,
        o.channel

    from stg_order_lines as ol
    left join int_orders_enriched as o
        on ol.order_id = o.order_id
    left join stg_products as p
        on ol.product_id = p.product_id

)

select * from joined
