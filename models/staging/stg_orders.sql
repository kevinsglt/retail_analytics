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

),

ordered as (
    select

        c.order_id,
        c.customer_id,
        c.store_id,
        c.order_datetime,
        c.order_status,
        c.payment_method,
        c.net_amount,
        row_number() over (
            partition by c.customer_id
            order by c.order_datetime, c.order_id
        ) as rn
    from cleaned as c
),

adjusted as (
    select
        customer_id,
        order_id,
        store_id,
        -- on simule un écart de 7 à 60 jours entre commandes d’un même client
        min(order_datetime) over (partition by customer_id)
        + ((rn - 1) * (interval '7 days' + random() * interval '53 days')) as order_datetime,
        order_status,
        payment_method,
        net_amount
    from ordered

),

filtered as (

    select *
    from adjusted
    where order_datetime <= current_timestamp

)

select * from filtered
