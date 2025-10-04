{# stg_stores.sql #}

with source as (
    select * from {{ source('raw', 'raw_stores') }}
),

cleaned as (

    select

        store_id,
        store_name,
        store_type,
        city,
        country

    from source

)

select * from cleaned
