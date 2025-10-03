{{ config(
    pre_hook=["ALTER SESSION SET TWO_DIGIT_CENTURY_START = 1950;"]
) }}
SELECT
    employee_id
    , exit_date
    , exit_reason_code
FROM {{ ref('s_departures') }}