{{ config(
    materialized = 'table', 
    pre_hook=["ALTER SESSION SET TWO_DIGIT_CENTURY_START = 1950;"]
) }}

SELECT
    CAST(emp_no AS INT) AS employee_id
    , TO_DATE(exit_date, 'MM/DD/YY') AS exit_date
    , CAST(exit_reason AS INT) AS exit_reason_code
FROM {{ source('employee_db_bronze', 'departures') }}
WHERE emp_no IS NOT NULL