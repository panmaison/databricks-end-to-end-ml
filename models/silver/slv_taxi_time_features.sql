with base as (

    select
        *,
        md5(concat_ws(
        '||',
        coalesce(cast(vendor_name as string), ''),
        coalesce(cast(pickup_datetime as string), ''),
        coalesce(cast(dropoff_datetime as string), ''),
        coalesce(cast(passenger_count as string), ''),
        coalesce(cast(trip_distance as string), ''),
        coalesce(cast(rate_code as string), ''),
        coalesce(cast(payment_type as string), ''),
        coalesce(cast(fare_amount as string), ''),
        coalesce(cast(tip_amount as string), ''),
        coalesce(cast(total_amount as string), ''),
        coalesce(cast(surcharge as string), ''),
        coalesce(cast(mta_tax as string), ''),
        coalesce(cast(tolls_amount as string), ''),
        coalesce(cast(start_lon as string), ''),
        coalesce(cast(start_lat as string), ''),
        coalesce(cast(end_lon as string), ''),
        coalesce(cast(end_lat as string), ''),
        coalesce(cast(store_and_forward as string), '')
    )) as trip_id,
        hour(pickup_datetime) as pickup_hour,
        dayofweek(pickup_datetime) as pickup_day_of_week,
        month(pickup_datetime) as pickup_month,
        case
            when dayofweek(pickup_datetime) in (1, 7) then 1
            else 0
        end as pickup_is_weekend
    from {{ ref('slv_taxi_trips_clean') }}
),

dedup as (

    select distinct *
    from base

)

select *
from dedup