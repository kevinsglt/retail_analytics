{# mart_customer_360.sql #}

with int_customers_enriched as (
    select * from {{ ref('int_customers_enriched') }}
),

int_customer_channel_spend as (
    select * from {{ ref('int_customer_channel_spend') }}
),

final as (

    select

        c.customer_id,
        c.age,
        c.gender,
        c.city,
        c.country,
        c.first_order_datetime,
        c.last_order_datetime,
        (current_date - cast(c.last_order_datetime as date)) as days_since_last_purchase,
        c.total_orders,
        c.total_spent_eur,
        round(cast(c.avg_order_value_eur as numeric), 0) as avg_order_value_eur,
        c.total_units,
        c.avg_unit_per_order,
        case
            when share_of_spend_ecom >= 0.5 then 'E-commerce'
            else 'Physique'
        end as preferred_channel

    from int_customers_enriched as c
    left join int_customer_channel_spend as cs
        on c.customer_id = cs.customer_id

)

select * from final
