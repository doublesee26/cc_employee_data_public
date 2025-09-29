{% docs employee_id_doc %}
The unique, primary identifier for an employee.
{% enddocs %}

{% docs title_id_doc %}
The identifier code for the employee's job title
{% enddocs %}

{% docs title_doc %}
The name of the employee's job title (e.g., 'Senior Engineer', 'HR Manager').
{% enddocs %}

{% docs birth_date_doc %}
The employee's date of birth. Used for age and tenure calculations.
{% enddocs %}

{% docs department_id_doc %}
The unique primary identifier for the department (e.g., 'd001').
{% enddocs %}

{% docs department_name_doc %}
Full name of the department (e.g., 'Marketing', 'Finance').
{% enddocs %}

{% docs salary_amount_doc %}
The amount of compensation paid to the employee for a specific period.
{% enddocs %}

{% docs exit_date_doc %}
The date when the employee left the company. If the employee is still active, this field may be null or set to a future date.
{% enddocs %}

{% docs exit_reason_code_doc %}
The reason code for the employee's departure
{% enddocs %}

{% docs agg_time_period %}
The aggregation period ('month', 'quarter', or 'year'). Used as a filter control (Period Selection).
{% enddocs %}

{% docs agg_event_start_date %}
The start date of the aggregated period (e.g., 2017-12-01). Used for trend axis.
{% enddocs %}

{% docs agg_is_current_period %}
Boolean flag (TRUE/FALSE) identifying the current reporting period. Used to filter for KPI boxes.
{% enddocs %}

{% docs agg_new_hires %}
Total new hires (new_comers) in the period. Used for line chart (Green line).
{% enddocs %}

{% docs agg_departures %}
Total departures (leavers) in the period. Used for line chart (Orange line) and KPI box 'Current Number of Leavers'.
{% enddocs %}

{% docs agg_previous_departures %}
departures at the START of the period. Used for calculating percent change.
{% enddocs %}

{% docs agg_net_change_departures %}
Change in departures from previous period (departures - previous_departures)
{% enddocs %}

{% docs agg_percent_change_departures %}
Percentage change in departures over the previous period. Used for the 'over previous Month/Quarter' metric.
{% enddocs %}

{% docs agg_headcount %}
Headcount at the END of the period (Headcount = Headcount_previous + Net Change). Used as the Current Headcounts KPI.
{% enddocs %}

{% docs agg_previous_headcount %}
Headcount at the START of the period. Used for calculating percent change.
{% enddocs %}

{% docs agg_net_change_headcount %}
Change in headcount from previous period (Headcount - previous_headcount).
{% enddocs %}

{% docs agg_percent_change_headcount %}
Percentage change in headcount over the previous period. Used for the 'over previous Month/Quarter' metric.
{% enddocs %}