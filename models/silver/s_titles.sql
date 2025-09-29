SELECT
    CAST(title_id AS VARCHAR) as title_id
    , CAST(title AS VARCHAR) AS title
FROM {{ source('employee_db_bronze', 'titles') }}
WHERE title_id IS NOT NULL