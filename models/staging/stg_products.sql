{# stg_products.sql #}

with source as (
    select * from {{ source('raw', 'raw_products') }}
),

cleaned as (

    select

        product_id,
        name,
        color,
        collection,
        product_display_name,
        category,
        price,
        cost

    from source

)

select * from cleaned
