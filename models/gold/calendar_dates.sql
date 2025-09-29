WITH date_spine AS (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('1950-01-01' as date)",
        end_date="DATE_TRUNC('DAY', DATEADD(YEAR, 3, LAST_DAY(CURRENT_DATE())))"
    )}}
    )

, add_boundary_dates AS (
    SELECT date_day FROM date_spine
    UNION ALL 
    SELECT CAST('1900-01-01' AS DATE) AS date_day
    UNION ALL
    SELECT CAST('9999-12-31' AS DATE) AS date_day
    )

, final AS (
    SELECT 
        date_day
        , YEAR(date_day) as year_number
        , MONTH(date_day) as month_number
        , DAYNAME(date_day) AS day_of_week_name
        , DAYOFWEEK(date_day) as day_of_week_number
        , DATE_TRUNC('quarter', date_day) AS quarter_start_date
        , DATEADD(DAY, -1, DATEADD(QUARTER, 1, DATE_TRUNC('quarter', date_day))) AS quarter_end_date
        , DATE_TRUNC('month', date_day) AS month_start_date
        , LAST_DAY(date_day) AS month_end_date
        , CASE 
            WHEN MONTH(date_day) IN (1, 2, 3) THEN 'Q1'
            WHEN MONTH(date_day) IN (4, 5, 6) THEN 'Q2'
            WHEN MONTH(date_day) IN (7, 8, 9) THEN 'Q3'
            ELSE 'Q4'
            END AS quarter_name
        , MONTHNAME(date_day) AS month_name_short
        , CASE WHEN DAYOFWEEK(date_day) IN (0, 6) THEN FALSE ELSE TRUE END AS is_weekday
        , (date_day = CURRENT_DATE()) AS is_current_day
        , (DATE_TRUNC('month', date_day) = DATE_TRUNC('month', CURRENT_DATE())) AS is_current_month
        , (DATE_TRUNC('quarter', date_day) = DATE_TRUNC('quarter', CURRENT_DATE())) AS is_current_quarter
    FROM add_boundary_dates
)

SELECT * FROM final