SELECT
    employee_id
    , salary_amount
FROM {{ ref('s_salaries') }}