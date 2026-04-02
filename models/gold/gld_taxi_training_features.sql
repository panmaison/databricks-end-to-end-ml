select
    trip_id,
    vendor_name,
    passenger_count,
    trip_distance,
    rate_code,
    payment_type,
    fare_amount,
    tip_amount,
    total_amount,
    surcharge,
    mta_tax,
    tolls_amount,
    start_lon,
    start_lat,
    end_lon,
    end_lat,
    pickup_datetime,
    hour(pickup_datetime) as pickup_hour,
    dayofweek(pickup_datetime) as pickup_day_of_week,
    month(pickup_datetime) as pickup_month,
    case
        when dayofweek(pickup_datetime) in (1, 7) then 1
        else 0
    end as pickup_is_weekend,
    avg_speed_mph,
    trip_duration_minutes as label
from {{ ref('slv_taxi_time_features') }}