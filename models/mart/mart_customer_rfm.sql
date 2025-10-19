{# mart_customer_retention.sql #}

with mart_customer_360 as (
    select * from {{ ref('mart_customer_360') }}
),

base as (

    select

        customer_id,
        days_since_last_purchase as recency_days,
        total_orders as frequency,
        total_spent_eur as monetary

    from mart_customer_360
),

seuil as (

    select

        percentile_cont(0.2) within group (order by recency_days) as recency_p20,
        percentile_cont(0.4) within group (order by recency_days) as recency_p40,
        percentile_cont(0.6) within group (order by recency_days) as recency_p60,
        percentile_cont(0.8) within group (order by recency_days) as recency_p80,

        percentile_cont(0.2) within group (order by frequency) as frequency_p20,
        percentile_cont(0.4) within group (order by frequency) as frequency_p40,
        percentile_cont(0.6) within group (order by frequency) as frequency_p60,
        percentile_cont(0.8) within group (order by frequency) as frequency_p80,

        percentile_cont(0.2) within group (order by monetary) as monetary_p20,
        percentile_cont(0.4) within group (order by monetary) as monetary_p40,
        percentile_cont(0.6) within group (order by monetary) as monetary_p60,
        percentile_cont(0.8) within group (order by monetary) as monetary_p80

    from base
),

score as (

    select

        b.customer_id,
        b.recency_days,
        b.frequency,
        b.monetary,

        case
            when b.recency_days <= s.recency_p20 then 5
            when b.recency_days <= s.recency_p40 then 4
            when b.recency_days <= s.recency_p60 then 3
            when b.recency_days <= s.recency_p80 then 2
            else 1
        end as r_score,

        case
            when b.frequency <= s.frequency_p20 then 1
            when b.frequency <= s.frequency_p40 then 2
            when b.frequency <= s.frequency_p60 then 3
            when b.frequency <= s.frequency_p80 then 4
            else 5
        end as f_score,

        case
            when b.monetary <= s.monetary_p20 then 1
            when b.monetary <= s.monetary_p40 then 2
            when b.monetary <= s.monetary_p60 then 3
            when b.monetary <= s.monetary_p80 then 4
            else 5
        end as m_score

    from base as b

    cross join seuil as s
),

label as (

    select

        customer_id,
        recency_days,
        frequency,
        monetary,
        r_score,
        f_score,
        m_score,
        (r_score + f_score + m_score) as rfm_score_total,
        concat(r_score, f_score, m_score) as rfm_code,

        case
            when r_score >= 4 and f_score >= 4 and m_score >= 4 then 'VIP'
            when r_score >= 3 and f_score >= 4 then 'Loyal'
            when r_score >= 4 and f_score <= 2 then 'New Potential'
            when r_score <= 2 and (f_score >= 3 or m_score >= 3) then 'At Risk'
            when r_score <= 2 and f_score <= 2 and m_score <= 2 then 'Dormant'
            else 'Regular'
        end as customer_segment

    from score
),

final as (

    select

        l.customer_id,
        l.recency_days,
        l.frequency,
        l.monetary,
        l.r_score,
        l.m_score,
        l.f_score,
        l.rfm_score_total,
        l.rfm_code,
        l.customer_segment,
        s.recency_p20,
        s.recency_p40,
        s.recency_p60,
        s.recency_p80,
        s.frequency_p20,
        s.frequency_p40,
        s.frequency_p60,
        s.frequency_p80,
        s.monetary_p20,
        s.monetary_p40,
        s.monetary_p60,
        s.monetary_p80

    from label as l
    cross join seuil as s
)

select * from final
