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
team_kpis AS (
SELECT
    function_all AS function_team_kpi,
    kpi_all AS team_kpi
    
FROM gather_all_kpis

GROUP BY 
    function_all,
    kpi_all
),

role_kpis AS (
SELECT 
    role,
    kpi AS role_kpi_selected
   -- function_all AS function_all_role

--FROM gather_all_kpis AS gather_all_kpis
from `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` 
--ON gather_all_kpis.function_all = role.function

GROUP BY 
    role,
    kpi
)
SELECT 
    function_all,
    --role_all,
    --role_kpi_selected,
    team_kpi,
    role,
    role_all,
    CASE 
        WHEN role_kpi_selected = team_kpi
        AND role <> role_all
        THEN 1
        ELSE 0
        END AS pullin,
    CASE
        WHEN function_all =function_team_kpi
        AND role <> role_all 
        AND role_kpi_selected <> team_kpi
        THEN team_kpi
        ELSE first_name
        END AS kpi_pull
FROM team_kpis AS team_kpis
LEFT JOIN role_kpis AS role_kpis
    ON role_kpi_selected = team_kpi
LEFT JOIN gather_all_kpis as gather_all
    ON gather_all.function_all = team_kpis.function_team_kpi

--WHERE team_kpi not in (select k2.role_kpi_selected from role_kpis AS k2 where function_all=k2.team_kpi_table )
GROUP BY
    function_all,
    function_team_kpi,
    first_name,
    --role_all,
    --role_kpi_selected,
    team_kpi,
    role_kpi_selected ,
    role,
    role_all

    

/*WHERE 
    a.role <> b.role_all
    AND kpi NOT IN (SELECT gather2.kpi_all FROM gather_all_kpis AS gather2 WHERE gather2.kpi_all <> kpi )
    
GROUP BY
    kpi,
    role,
    function,
    role_all,
    function_all,
    kpi_all
  

/*
(SELECT gather2.kpi_all 
    FROM gather_kpis_by_team AS gather2 
    WHERE a.role <> gather2.role_all
    AND a.function = gather2.function_all
    AND a.kpi <> gather2.kpi_all) AS open_kpi
    */