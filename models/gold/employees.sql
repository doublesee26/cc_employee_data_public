{{ config(
    pre_hook=["ALTER SESSION SET TWO_DIGIT_CENTURY_START = 1950;"]
) }}
SELECT
    employee_id
    , employee_title_id
    , birth_date
    , first_name
    , last_name
    , sex
    , hire_date
FROM {{ ref('s_employees') }}
