SELECT
    employee_id
    , department_id
FROM {{ ref('s_dept_manager') }}
