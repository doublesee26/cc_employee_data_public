{{ config(
    pre_hook=["ALTER SESSION SET TWO_DIGIT_CENTURY_START = 1950;"]
) }}
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
FROM {{ ref('s_employees') }}
