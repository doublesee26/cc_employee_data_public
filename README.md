# Project Handover Documentation: Employee Fluctuation Reporting

This project successfully built a robust **dbt data pipeline** that aggregates raw HR data into three highly efficient Analytics Layer tables, specifically designed to power the **[Employee Fluctuation Dashboard](https://public.tableau.com/app/profile/starschema/viz/Fluctuationreport/Fluctuationreport)** in Tableau.

To build and maintain the Tableau report, you only need to connect to these three final aggregate models (all located under the **Analytics schema**). The core business logic (e.g., Age, Generation, Headcount, Percent Change) is **pre-calculated** within these models.

## 💾 Guide to the Three Aggregate Tables

These are the final, optimized tables you will connect to directly in your reporting tool (Tableau).

| Tableau View | Purpose | dbt Model | Key Dimensions & Metrics | 
 | ----- | ----- | ----- | ----- | 
| **KPI Boxes & Trends** | High-level Headcount, Hires, and Leavers trends across the entire company. | `agg_fluctuation_metrics` | `time_period`, `event_start_date`, `headcount`, `departures` | 
| **Department Breakdown** | Time-series analysis of Hires and Leavers by Department. | `agg_fluctuation_metrics_by_department` | `time_period`, `event_start_date`, `department_name`, `new_hires`, `departures` | 
| **Demographic Analysis** | Detailed analysis of departed employees by personal attributes. | `agg_departure_metrics` | `employee_generation`, `tenure_group`, `exit_reason_code`, `tenure_years` | 

### **How to Build the Key Visuals (Tableau Quick Start)**

| Visual Component | Source Table | Dimensions (Rows/Columns) | Measure (Count/Value) | Filter/Logic | 
 | ----- | ----- | ----- | ----- | ----- | 
| **Current Headcount KPI** | `agg_fluctuation_metrics` | N/A | `headcount` | Filter: `is_current_period` = TRUE AND `time_period` = 'month' (or 'quarter') | 
| **Monthly Trend Line** | `agg_fluctuation_metrics` | Columns: `event_start_date` (Month) | `new_hires` & `departures` | Filter: `time_period` = 'month' | 
| **Generation Donut Chart** | `agg_departure_metrics` | `employee_generation` | Count of `employee_id` | N/A (or filter by specific `exit_date` range) | 
| **Tenure Group Bar Chart** | `agg_departure_metrics` | `tenure_group` | Count of `employee_id` | N/A | 
| **Headcount % Change KPI** | `agg_fluctuation_metrics` | N/A | `percent_change_headcount` | Filter: `is_current_period` = TRUE | 

## 🛠 Process Documentation: Project Setup and Data Flow

The project follows the **Kimball methodology**, implemented via a dbt project structure.

### **1. Project Setup and Infrastructure**

| System | Role in Pipeline | Configuration Notes | 
 | ----- | ----- | ----- | 
| **Source Data** | Raw HR data storage. | Files uploaded to Google Cloud Storage (GCS) bucket. | 
| **Ingestion** | ETL/ELT tool for moving raw data. | **Fivetran Account** configured to pull from the GCS bucket and load directly into Snowflake. Fivetran handles schema mapping and initial sync. | 
| **Data Warehouse** | Storage and compute for modeling. | **Snowflake Account**. Dedicated roles (`fivetran_role`, `dbt_role`) and users were created and granted appropriate read/write permissions for security. | 
| **Modeling** | Transformation and orchestration. | **dbt Project** connected to a GitHub repository (for version control) and a Snowflake connection. | 

### **2. dbt Layer Actions Taken**

The dbt project uses a multi-layered approach to ensure data quality and optimized performance.

| Layer | Purpose | Key Actions Performed | 
 | ----- | ----- | ----- | 
| **Bronze (Source)** | Raw, untouched data. | Defined sources for `employees`, `departures`, `departments`, and `dept_emp`. | 
| **Silver (Staging)** | Cleaned, standardized data. | Data Type Updates (e.g., ensuring all dates are consistent). **Uniqueness Tests** set on primary keys. Initial NULLs removal applied. | 
| **Intermediate (Modulating)** | Complex, shared logic. | Used for modulating and consolidating complex logic (e.g., initial employee movement calculation) before final aggregation. | 
| **Gold** | Business-ready, cleaned tables | Final cleaning and testing. | 
| **Analytics** | Optimized tables built for reports. | Created the three final aggregate models. Built-in business logic: Age, Generation, Tenure, Headcount running sum, and Period Change Metrics. Uniqueness and not-null tests applied. | 

### **3. Data Scope**

| Used for Report | Not Currently Used (Future Slices) | 
 | ----- | ----- | 
| `employees`, `departures`, `departments`, `dept_emp` | `titles`, `salaries`, `dept_managers` | 

### **Project Data Lineage**

The three primary Analytics models are the final consumption layer:

* `agg_fluctuation_metrics`

* `agg_fluctuation_metrics_by_department` (Powers the Department Bar Charts)

* `agg_departure_metrics`

<img width="1216" height="450" alt="image" src="https://github.com/user-attachments/assets/4c9acd97-c89b-43eb-915f-5ee81970b872" />


## 🚀 Future Updates and Recommendations

The current pipeline is functional but relies on several assumptions due to limitations in the source data. Addressing the following items is critical for long-term scalability and accuracy.

### **A. Data Ingestion & Quality Fixes (High Priority)**

1. **Date Ingestion Reliability:** Investigate and fix the date data ingestion issues noted during setup. Ensuring smoother pipeline functionality requires robust date parsing at the earliest stage possible (Bronze/Silver).

2. **Reason Code Mapping:** The analysis currently uses `exit_reason_code`. A future update must provide a **mapping table** to match these codes to human-readable reason descriptions to make the 'Why did they leave?' chart actionable.

3. **Target Data:** Target headcount data is missing. This is essential for comparing actual headcount against business goals. A staging table (`department_targets`) needs to be created and ingested.

### **B. Core Data Model Enhancements (High Value)**

1. **Temporal Relationship Data:** The most significant limitation is the lack of start and end dates for historical relationships (e.g., employee-department links, salary history).

   * **Recommendation:** If possible, acquire historical data. This would allow for enforcing 1:1 relationships at a specific point in time (employee in department on `date_x`) and answering precise time-related questions.

2. **Location Data:** Location data is missing entirely. This prevents the use of the requested Location filter. A staging table for location must be sourced and integrated into the `dept_emp` or `departments` models.

3. **Fluctuation Model Consolidation (DRY Principle):** The `agg_fluctuation_metrics` and `agg_fluctuation_metrics_by_department` models contain overlapping logic.

   * **Recommendation:** Build a **macro** to define the core aggregation logic and call it within both models to reduce code redundancy (making the code DRY - **D**on't **R**epeat **Y**ourself). This will simplify maintenance.

### **C. Future Analytical Slices**

If HR requires different views, the currently unused tables provide future opportunities:

* **Titles:** Analyze fluctuation rates by Job Title/Function.

* **Salaries:** Analyze fluctuation rates by Salary Band or identify salary compression issues for leavers.

* **Managers:** Analyze fluctuation rates by reporting manager (`dept_managers`).






