SELECT
    CAST(dept_no AS VARCHAR) AS department_id
    , CAST(dept_name AS VARCHAR) AS department_name
FROM {{ source('employee_db_bronze', 'departments') }}
WHERE dept_no IS NOT NULL