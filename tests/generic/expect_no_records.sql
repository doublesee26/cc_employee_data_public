{% test expect_no_records (model, where_condition) %}

SELECT *
 FROM {{model}} 
 WHERE {{where_condition}}

{% endtest %}
