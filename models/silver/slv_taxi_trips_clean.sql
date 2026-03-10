{{ config(
    materialized='table',
    schema='silver'
) }}

with base as (

    select
        vendor_id,
        tpep_pickup_datetime as pickup_datetime,
        tpep_dropoff_datetime as dropoff_datetime,
        cast(passenger_count as int) as passenger_count,
        cast(trip_distance as double) as trip_distance,
        cast(ratecodeid as int) as rate_code,
        cast(pulocationid as int) as pickup_location_id,
        cast(dolocationid as int) as dropoff_location_id,
        cast(payment_type as int) as payment_type,
        cast(fare_amount as double) as fare_amount,
        cast(tip_amount as double) as tip_amount,
        cast(total_amount as double) as total_amount
    from {{ ref('br_yellow_taxi') }}

),

derived as (

    select
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        passenger_count,
        trip_distance,
        rate_code,
        pickup_location_id,
        dropoff_location_id,
        payment_type,
        fare_amount,
        tip_amount,
        total_amount,

        timestampdiff(
            second,
            pickup_datetime,
            dropoff_datetime
        ) / 60.0 as trip_duration_minutes,

        trip_distance / (
            timestampdiff(
                second,
                pickup_datetime,
                dropoff_datetime
            ) / 3600.0
        ) as avg_speed_mph

    from base
    where pickup_datetime is not null
      and dropoff_datetime is not null
      and dropoff_datetime > pickup_datetime

),

filtered as (

    select *
    from derived
    where trip_duration_minutes between 1 and 180
      and trip_distance between 0.1 and 50
      and passenger_count between 1 and 6
      and fare_amount >= 0
      and total_amount >= 0
      and avg_speed_mph between 2 and 80

)

select *
from filtered