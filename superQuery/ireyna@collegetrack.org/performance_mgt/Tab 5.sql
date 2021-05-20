/*
CREATE OR REPLACE TABLE `data-warehouse-289815.performance_mgt.fy22_roles_kpis_open`
OPTIONS
    (
    description="This table lists KPIs available for staff to select based on role during Individual KPI selection phase. If a KPI is on the staff member's team, they can select pre-determined KPIs on their team that was not mapped to their role. "
    )
AS
*/
WITH 

gather_all_kpis AS (
SELECT
    first_name,
    last_name,
    function,
    role,
    kpi AS team_kpi
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi`
),
kpi_by_team AS (
SELECT 
    function,
    kpi
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi`
GROUP BY 
    function,kpi
)
SELECT 
    role,kpi,function
 
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi`  AS a
WHERE kpi NOT IN 
    (SELECT kpi 
    FROM gather_all_kpis AS b
    WHERE a.function = b.function)
GROUP BY role, kpi, function
--SELECT "corba" IN (SELECT account FROM Players) as result;

/*
 (SELECT kpi 
    FROM gather_all_kpis AS b 
    WHERE team_kpi <> KPI 
    AND a.function = b.function) as kpis_not_assigned
    */
--                (SELECT b.KPI 
--                FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` AS b
--                WHERE a.function = b.function
--                GROUP BY b.first_name,b.last_name,b.kpi)