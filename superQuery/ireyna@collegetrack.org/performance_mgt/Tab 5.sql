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
    kpi
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi`
)
SELECT
    a.first_name,
    a.last_name,
    a.function,
    a.role,
    (SELECT kpi 
        FROM gather_all_kpis AS b 
        WHERE a.function = b.function 
        AND a.kpi <> b.kpi) AS kpi

FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi`  AS a
       

--WHERE kpi NOT IN 
--                (SELECT b.KPI 
--                FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` AS b
--                WHERE a.function = b.function
--                GROUP BY b.first_name,b.last_name,b.kpi)