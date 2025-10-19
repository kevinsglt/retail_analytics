{# int_customer_channel_spend.sql #}

with int_orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
),

base as (

    select

        customer_id,
        channel,
        sum(net_amount) as spend_by_channel

    from int_orders_enriched

    group by customer_id, channel

),

total as (

    select

        customer_id,
        sum(spend_by_channel) as total_spent_eur

    from base

    group by customer_id

),

final as (

    select

        t.customer_id,
        round(cast((sum(case when b.channel = 'E-COMMERCE' then b.spend_by_channel else 0 end) / max(t.total_spent_eur)) as numeric), 2) as share_of_spend_ecom,
        round(cast((sum(case when b.channel in ('FLAGSHIP', 'BOUTIQUE') then b.spend_by_channel else 0 end) / max(t.total_spent_eur)) as numeric), 2) as share_of_spend_physique

    from total as t
    left join base as b
        on t.customer_id = b.customer_id
    group by t.customer_id

)

select * from final
