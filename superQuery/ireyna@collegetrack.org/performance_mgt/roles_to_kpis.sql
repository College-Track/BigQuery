
CREATE OR REPLACE TABLE `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi`
OPTIONS
    (
    description="This table maps CT-wide Staff List to finalized KPIs based on Role for FY22"
    )
AS

WITH gather_staff_table AS (
SELECT *
FROM `data-warehouse-289815.google_sheets.staff_list`
),

gather_kpis AS (
SELECT *
FROM `data-studio-260217.performance_mgt.role_kpi_selection`
)

SELECT 
    staff.* EXCEPT(position_id, team),
    kpis.*,
    CASE WHEN kpi IS NULL THEN 1
        ELSE 0
        END AS missing_kpis
FROM gather_staff_table AS staff
LEFT JOIN gather_kpis AS kpis 
ON staff.Job_Title_Description = kpis.Role
--AND staff.Team = kpis.function

