SELECT
    title_id
    , title
FROM {{ ref('s_titles') }}