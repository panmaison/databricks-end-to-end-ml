select
    *,
    hour(pickup_datetime) as pickup_hour,
    dayofweek(pickup_datetime) as pickup_day_of_week,
    month(pickup_datetime) as pickup_month,
    case
        when dayofweek(pickup_datetime) in (1, 7) then 1
        else 0
    end as pickup_is_weekend
from {{ ref('slv_taxi_trips_clean') }}