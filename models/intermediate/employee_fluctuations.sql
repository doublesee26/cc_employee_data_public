SELECT
    employee_id
    , hire_date as event_date
    , 'Hire' as event_type 
FROM {{ ref('employees') }}

UNION ALL 

SELECT 
    employee_id 
    , exit_date as event_date 
    , 'Departure' as event_type 
FROM {{ ref('departures') }}