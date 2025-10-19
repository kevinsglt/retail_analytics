{# mart_customer_retention.sql #}

with stg_orders as (
    select * from {{ ref('stg_orders') }}
),

base as (

    select

        customer_id,
        date_trunc('month', order_datetime) as order_month,
        date_trunc('month', min(order_datetime) over (partition by customer_id)) as cohort_month

    from stg_orders

),

activity as (

    select

        customer_id,
        cohort_month,
        order_month,
        date_part('month', age(order_month, cohort_month))
        + 12 * (date_part('year', age(order_month, cohort_month))) as period_month

    from base
),

active_customers as (

    select

        cohort_month,
        period_month,
        count(distinct customer_id) as active_customers

    from activity

    group by cohort_month, period_month

),

cohort_size as (

    select

        cohort_month,
        count(distinct customer_id) as cohort_size

    from activity

    where period_month = 0

    group by cohort_month

),

final as (

    select

        a.cohort_month,
        a.period_month,
        c.cohort_size,
        a.active_customers,
        round((cast(a.active_customers as numeric) / cast(c.cohort_size as numeric)), 3) as retention_rate,
        round(1 - (cast(a.active_customers as numeric) / cast(c.cohort_size as numeric)), 3) as churn_rate

    from active_customers as a

    left join cohort_size as c
        on a.cohort_month = c.cohort_month

    order by cohort_month, period_month

)

select * from final
