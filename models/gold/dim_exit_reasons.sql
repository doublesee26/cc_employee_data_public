SELECT  
    exit_reason_code
    ,exit_reason_name
FROM {{ ref('s_exit_reasons') }}