{{ config(
    materialized = 'table', 
    pre_hook=["ALTER SESSION SET TWO_DIGIT_CENTURY_START = 1950;"]
) }}
SELECT
    CAST(emp_no AS INT) AS employee_id
    , CAST(emp_title_id AS VARCHAR) AS employee_title_id
    , TO_DATE(birth_date, 'MM/DD/YY') AS birth_date
    , CAST(first_name AS VARCHAR) AS first_name
    , CAST(last_name AS VARCHAR) AS last_name
    , CAST(sex AS VARCHAR) AS sex
    , TO_DATE(hire_date, 'MM/DD/YY') AS hire_date
FROM {{ source('employee_db_bronze', 'employees') }}
WHERE emp_no IS NOT NULL
