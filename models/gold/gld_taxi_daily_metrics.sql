select
    cast(pickup_datetime as date) as trip_date,
    count(*) as trip_count,
    avg(trip_distance) as avg_trip_distance,
    avg(trip_duration_minutes) as avg_trip_duration_minutes,
    avg(total_amount) as avg_total_amount
from {{ ref('slv_taxi_time_features') }}
group by cast(pickup_datetime as date)