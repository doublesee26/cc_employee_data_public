{% set time_periods = [
    'month'
] %}


WITH bring_in_department as (
    SELECT 
        ef.*
        , d.department_name
    FROM {{ ref('employee_fluctuations') }} ef 
    LEFT JOIN {{ ref('fct_department_employee') }} de 
        ON ef.employee_id = de.employee_id
    LEFT JOIN {{ ref('dim_departments') }} d 
        ON de.department_id = d.department_id 
)

, time_period_fluctuations as (
    {% for time_period in time_periods %}
    SELECT 
        '{{ time_period }}' as time_period
        , DATE_TRUNC('{{ time_period }}', event_date) as event_start_date
        , DATE_TRUNC('{{ time_period }}', event_date) = DATE_TRUNC('{{ time_period }}', CURRENT_DATE()) as is_current_period
        , department_name
        , COUNT(DISTINCT CASE WHEN event_type = 'Hire' THEN employee_id END) as new_hires 
        , COUNT(DISTINCT CASE WHEN event_type = 'Departure' THEN employee_id END) as departures
    FROM bring_in_department
    GROUP BY ALL
    {% if not loop.last %}UNION ALL{% endif %}
    {% endfor %}
)

, get_headcount as (
    SELECT 
        time_period
        , event_start_date
        , is_current_period
        , department_name
        , new_hires
        , departures 
        , SUM(new_hires - departures) OVER (PARTITION BY time_period, department_name ORDER BY event_start_date ASC) as headcount
    FROM time_period_fluctuations
)

SELECT * 
FROM get_headcount