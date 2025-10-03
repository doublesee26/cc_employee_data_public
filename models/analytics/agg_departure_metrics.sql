
WITH get_age_and_generation AS (
    SELECT
        employee_id
        , employee_title_id
        , birth_date
        , DATEDIFF('year', birth_date, CURRENT_DATE()) - 
            CASE 
                WHEN MONTH(birth_date) > MONTH(CURRENT_DATE()) THEN 1
                WHEN MONTH(birth_date) = MONTH(CURRENT_DATE()) AND DAY(birth_date) > DAY(CURRENT_DATE()) THEN 1
                ELSE 0 
            END AS employee_age
        , CASE
            WHEN YEAR(birth_date) BETWEEN 1928 AND 1945 THEN 'Silent Generation'   -- 1928-1945
            WHEN YEAR(birth_date) BETWEEN 1946 AND 1964 THEN 'Baby Boomers'        -- 1946-1964
            WHEN YEAR(birth_date) BETWEEN 1965 AND 1980 THEN 'Generation X'        -- 1965-1980
            WHEN YEAR(birth_date) BETWEEN 1981 AND 1996 THEN 'Millennials (Gen Y)' -- 1981-1996
            WHEN YEAR(birth_date) BETWEEN 1997 AND 2012 THEN 'Generation Z'        -- 1997-2012
            ELSE 'Unknown/Historical'
            END AS employee_generation
        , first_name
        , last_name
        , sex
        , hire_date
    FROM {{ ref('dim_employees') }}
    )

, get_exit_date as (
    SELECT
        e.employee_id
        , e.employee_title_id
        , e.birth_date
        , e.employee_age
        , e.employee_generation
        , e.first_name
        , e.last_name
        , e.sex
        , e.hire_date
        , d.exit_date
        , d.exit_reason_code
        , er.exit_reason_name
        , DATEDIFF('year', e.hire_date, d.exit_date) as tenure_years
    FROM get_age_and_generation e
    INNER JOIN {{ ref('fct_departures') }} d 
        ON e.employee_id = d.employee_id
    LEFT JOIN {{ ref('dim_exit_reasons') }} er 
        ON d.exit_reason_code = er.exit_reason_code
    )

, get_tenure_group as (
    SELECT 
        *
        , CASE
            WHEN tenure_years < 1 THEN '< 1'
            WHEN tenure_years < 2 THEN '1-2'
            WHEN tenure_years < 3 THEN '2-3'
            WHEN tenure_years < 5 THEN '3-5'
            ELSE '5+'
            END AS tenure_group
    FROM get_exit_date
    )

SELECT * 
FROM get_tenure_group