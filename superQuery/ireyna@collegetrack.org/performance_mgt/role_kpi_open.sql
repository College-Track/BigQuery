/*
CREATE OR REPLACE TABLE `data-warehouse-289815.performance_mgt.fy22_roles_kpis_open`
OPTIONS
    (
    description="This table lists KPIs available for staff to select based on role during Individual KPI selection phase. If a KPI is on the staff member's team, they can select pre-determined KPIs on their team that was not mapped to their role. "
    )
AS
*/

WITH 

gather_kpis_by_team AS (
SELECT
    first_name,
    last_name,
    function AS function_all,
    role AS role_all,
    kpi AS kpi_all
    
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi`
),


--KPIs on someone's team, but not mapped to their specific role KPIs.
--They can select the KPIs on their team that is not one of their KPIs based on their role (MUST be a KPI on their team)
--Exception: CCAs- they will be able to enter a caseload size and cutomized target for their role during the Inidivudal KPI Selection phase
team_kpis_not_assigned_to_role AS (
SELECT
    b.first_name,
    b.last_name,
    kpi_all,
    role_all,
    function_all,
    kpi,
    role,
    function,
    CASE 
        WHEN role <> role_all
        AND kpi = kpi_all
        AND function = function_all
        THEN kpi
        ELSE "already a kpi"
    END AS open_kpis

FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` AS a
LEFT JOIN gather_kpis_by_team AS b
    ON a.function = b.function_all

GROUP BY
    b.first_name,
    b.last_name,
    kpi,
    role,
    function,
    kpi_all,
    role_all,
    function_all
)

SELECT 
    role,
    kpi,
    function,
    kpi_all
FROM team_kpis_not_assigned_to_role
/*    
WHERE kpi NOT IN 
    (SELECT kpi_all FROM gather_kpis_by_team AS c
    WHERE function = function_all
    AND role <> role_all)
    AND function = function_all
    AND role <> role_all
*/