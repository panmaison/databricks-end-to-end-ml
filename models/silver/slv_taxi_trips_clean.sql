{{ config(
    materialized='table',
    schema='silver'
) }}

with base as (

    select
        vendor_name,
        Trip_Pickup_DateTime as pickup_datetime,
        Trip_Dropoff_DateTime as dropoff_datetime,
        cast(Passenger_Count as int) as passenger_count,
        cast(Trip_Distance as double) as trip_distance,
        cast(Rate_Code as string) as rate_code,
        cast(Payment_Type as string) as payment_type,
        cast(Fare_Amt as double) as fare_amount,
        cast(Tip_Amt as double) as tip_amount,
        cast(Total_Amt as double) as total_amount,
        cast(Start_Lon as double) as start_lon,
        cast(Start_Lat as double) as start_lat,
        cast(End_Lon as double) as end_lon,
        cast(End_Lat as double) as end_lat,
        cast(store_and_forward as int) as store_and_forward,
        cast(surcharge as double) as surcharge,
        cast(mta_tax as double) as mta_tax,
        cast(Tolls_Amt as double) as tolls_amount
    from {{ ref('br_yellow_taxi') }}

),

derived as (

    select
        vendor_name,
        pickup_datetime,
        dropoff_datetime,
        passenger_count,
        trip_distance,
        rate_code,
        payment_type,
        fare_amount,
        tip_amount,
        total_amount,
        start_lon,
        start_lat,
        end_lon,
        end_lat,
        store_and_forward,
        surcharge,
        mta_tax,
        tolls_amount,

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