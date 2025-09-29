{% set time_periods = [
    'month',
    'quarter',
    'year'
] %}


WITH time_period_fluctuations as (
    {% for time_period in time_periods %}
    SELECT 
        '{{ time_period }}' as time_period
        , DATE_TRUNC('{{ time_period }}', event_date) as event_start_date
        , DATE_TRUNC('{{ time_period }}', event_date) = DATE_TRUNC('{{ time_period }}', CURRENT_DATE()) as is_current_period
        , COUNT(DISTINCT CASE WHEN event_type = 'Hire' THEN employee_id END) as new_hires 
        , COUNT(DISTINCT CASE WHEN event_type = 'Departure' THEN employee_id END) as departures
    FROM {{ ref('employee_fluctuations') }}
    GROUP BY ALL
    {% if not loop.last %}UNION ALL{% endif %}
    {% endfor %}
)

, get_headcount as (
    SELECT 
        time_period
        , event_start_date
        , is_current_period
        , new_hires
        , departures 
        , SUM(new_hires - departures) OVER (PARTITION BY time_period ORDER BY event_start_date ASC) as headcount
    FROM time_period_fluctuations
)

, get_previous_period_headcount as (
    SELECT 
        time_period
        , event_start_date
        , is_current_period
        , new_hires
        , departures 
        , COALESCE(LAG(departures) OVER (PARTITION BY time_period ORDER BY event_start_date ASC),0) as previous_departures
        , headcount
        , COALESCE(LAG(headcount) OVER (PARTITION BY time_period ORDER BY event_start_date ASC),0) as previous_headcount
    FROM get_headcount
)

SELECT 
    *
    ,(departures - previous_departures) as net_change_departures
    ,(departures - previous_departures) / NULLIF(previous_departures, 0) as percent_change_departures
    ,(headcount - previous_headcount) as net_change_headcount
    ,(headcount - previous_headcount) / NULLIF(previous_headcount, 0) as percent_change_headcount
FROM get_previous_period_headcount
