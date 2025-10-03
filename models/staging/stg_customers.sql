{# stg_customers.sql #}

with source as (
    select * from {{ source('raw', 'raw_customers') }}
),

cleaned as (

    select

        customer_id,
        cast(first_purchase_date as date) as first_purchase_at,
        country,
        city,
        gender,
        birth_year

    from source

)

select * from cleaned
