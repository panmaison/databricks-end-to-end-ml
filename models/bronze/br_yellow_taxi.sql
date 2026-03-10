{{ config(
    materialized='view',
    schema='bronze'
) }}

select *
from {{ source('bronze', 'yellow_taxi_raw') }}