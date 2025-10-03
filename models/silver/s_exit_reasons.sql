SELECT
    exit_reason_code
    ,exit_reason_name
FROM {{ ref('exit_reasons') }}