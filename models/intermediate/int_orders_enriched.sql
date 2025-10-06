{# int_orders_enriched.sql #}

with stg_orders as (
    select * from {{ ref('stg_orders') }}
),

stg_stores as (
    select * from {{ ref('stg_stores') }}
),

joined as (

    select

        o.order_id,
        o.customer_id,
        o.store_id,
        o.order_date,
        o.net_amount,
        o.payment_method,
        o.order_status,
        s.store_type as channel

    from stg_orders as o

    left join stg_stores as s
        on o.store_id = s.store_id

)

select * from joined
