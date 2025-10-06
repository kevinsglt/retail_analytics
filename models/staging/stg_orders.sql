{# stg_orders.sql #}

with source as (
    select * from {{ source('raw', 'raw_orders') }}
),

cleaned as (

    select

        order_id,
        customer_id,
        store_id,
        cast(order_datetime as timestamp) as order_datetime,
        order_status,
        payment_method,
        net_amount

    from source

)

select * from cleaned
