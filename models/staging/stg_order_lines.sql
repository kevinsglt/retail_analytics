{# stg_order_lines.sql #}

with source as (
    select * from {{ source('raw', 'raw_order_lines') }}
),

cleaned as (

    select

        order_line_id,
        order_id,
        product_id,
        quantity

    from source

)

select * from cleaned
