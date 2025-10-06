{# int_customers_first_order.sql #}

with int_orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
),

first_orders as (

    select

        customer_id,
        order_datetime,
        date_trunc('month', order_datetime) as first_order_month,
        store_id as first_order_store_id,
        payment_method as first_order_payment,
        order_status as first_order_status,
        net_amount as first_order_amount,
        row_number() over (
            partition by customer_id
            order by order_datetime asc, order_id asc
        ) as rn

    from int_orders_enriched

),

joined as (

    select

        customer_id,
        order_datetime as first_order_datetime,
        first_order_month,
        first_order_store_id,
        first_order_payment,
        first_order_status,
        first_order_amount

    from first_orders
    where rn = 1

)

select * from joined
