select
    vendor_name,
    passenger_count,
    trip_distance,
    rate_code,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    pickup_hour,
    pickup_day_of_week,
    pickup_month,
    pickup_is_weekend,
    fare_amount,
    tip_amount,
    total_amount,
    trip_duration_minutes as label
from {{ ref('slv_taxi_time_features') }}