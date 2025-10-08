{# int_customers_enriched.sql #}

with stg_customers as (
    select * from {{ ref('stg_customers') }}
),

int_customers_first_order as (
    select * from {{ ref('int_customers_first_order') }}
),

int_customers_orders_summary as (
    select * from {{ ref('int_customers_orders_summary') }}
),

base as (

    select

        c.customer_id,
        c.birth_year,
        extract(year from current_date) - c.birth_year as age,
        c.country,
        c.city,
        c.gender,
        cfo.first_order_datetime,
        cfo.first_order_store_id,
        cfo.first_order_payment,
        cfo.first_order_amount,
        cos.last_order_datetime,
        cos.total_orders,
        cos.total_spent_eur,
        cos.avg_order_value_eur,
        (cast(cos.last_order_datetime as date) - cast(cfo.first_order_datetime as date)) as customer_lifetime_days

    from stg_customers as c
    left join int_customers_first_order as cfo
        on c.customer_id = cfo.customer_id
    left join int_customers_orders_summary as cos
        on c.customer_id = cos.customer_id

)

select * from base
