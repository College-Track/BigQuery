/*
CREATE OR REPLACE TABLE `data-warehouse-289815.performance_mgt.roles_to_kpi`
OPTIONS
    (
    description="This table maps CT-wide Staff List to KPIs based on Role anf Function/Team"
    )
AS
*/
WITH
gather_staff_table AS (
SELECT *
FROM `data-warehouse-289815.google_sheets.staff_table`
),

gather_kpis AS (
SELECT *
FROM `data-studio-260217.performance_mgt.role_kpi_selection`
)

SELECT *
FROM gather_staff_table AS staff
LEFT JOIN gather_kpis AS kpis ON staff.Job_Title_Description = kpis.Role