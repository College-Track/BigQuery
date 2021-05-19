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

GROUP BY
    first_name,
    last_name,
    function,
    role,
    kpi
    
),


--KPIs on someone's team, but not mapped to their specific role KPIs.
--They can select the KPIs on their team that is not one of their KPIs based on their role (MUST be a KPI on their team)
--Exception: CCAs- they will be able to enter a caseload size and cutomized target for their role during the Inidivudal KPI Selection phase
team_kpis_not_assigned_to_role AS (
SELECT
    --b.first_name,
    --b.last_name,
    --kpi_all,
    --role_all,
    --function_all,
    kpi AS open_kpi,
    role,
    function
    
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` AS a
LEFT JOIN gather_kpis_by_team AS b
    ON a.function = b.function_all
WHERE 
    a.role <> b.role_all
    AND a.function = b.function_all
    AND a.kpi <> b.kpi_all 
    
GROUP BY
    --b.first_name,
    --b.last_name,
    kpi,
    role,
    function
    --kpi_all,
    --role_all,
    --function_all
)

SELECT 
    role,
    open_kpi,
    --kpi,
    function,
    --kpi_all
FROM team_kpis_not_assigned_to_role
GROUP BY
    role,
    open_kpi,
    function
    --kpi,
    --kpi_all

/*
(SELECT gather2.kpi_all 
    FROM gather_kpis_by_team AS gather2 
    WHERE a.role <> gather2.role_all
    AND a.function = gather2.function_all
    AND a.kpi <> gather2.kpi_all) AS open_kpi
    */