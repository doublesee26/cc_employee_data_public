SELECT
    CAST(emp_no AS INT) AS employee_id
    , CAST(salary AS INT) AS salary_amount
FROM {{ source('employee_db_bronze', 'salaries') }}
WHERE emp_no IS NOT NULL 
    AND salary IS NOT NULL