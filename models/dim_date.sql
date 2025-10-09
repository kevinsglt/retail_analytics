{# dim_date.sql #}

{{ config(materialized='table') }}

with calendar as (

    select cast(temporary_date as date) as calendar_date

    from generate_series(

        date '2016-01-01',              -- Date de départ (fixe)
        current_date + interval '12 months',  -- Horizon futur (ici +12 mois)
        interval '1 day'

    ) as temporary_date
)

select

    calendar_date,

    -- Calendrier ISO
    cast(extract(isoyear from calendar_date) as int) as iso_year,
    cast(extract(week from calendar_date) as int) as iso_week,
    cast(date_trunc('week', calendar_date) as date) as iso_week_start,
    cast((date_trunc('week', calendar_date) + interval '6 day') as date) as iso_week_end,

    -- Calendrier civil
    cast(extract(year from calendar_date) as int) as calendar_year,
    cast(extract(quarter from calendar_date) as int) as calendar_quarter,
    cast(extract(month from calendar_date) as int) as calendar_month,
    to_char(calendar_date, 'YYYY-MM') as calendar_year_month,
    cast(extract(isodow from calendar_date) as int) as iso_day_of_the_week,
    (extract(isodow from calendar_date) in (6, 7)) as is_weekend

from calendar

order by calendar_date
