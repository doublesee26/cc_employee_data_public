SELECT
    CAST(emp_no AS INT) AS employee_id
    , CAST(dept_no AS VARCHAR) AS department_id
FROM {{ source('employee_db_bronze', 'dept_emp') }}
WHERE emp_no IS NOT NULL 
    AND dept_no IS NOT NULL