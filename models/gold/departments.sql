SELECT
    department_id
    , department_name
FROM {{ ref('s_departments') }}