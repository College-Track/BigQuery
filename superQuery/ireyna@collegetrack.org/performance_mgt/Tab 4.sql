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
    function AS function_team,
    kpi AS team_kpi
FROM  `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` 
GROUP BY 
    function,
    kpi
),

role_kpis AS (
SELECT 
    role,
    kpi AS role_kpi_selected
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` 
GROUP BY 
    role,
    kpi
)
SELECT
distinct role,
function_all,
(select kpi_all from team_kpis where function_team = function_all AND team_kpi <> role_kpi_selected group by kpi_all)
role_kpi_selected,
CASE
    when role_kpi_selected <> kpi_all  THEN 'not a match'
    else 'same kpi'
    end as audit
FROM role_kpis AS a
LEFT JOIN gather_all_kpis AS b
ON b.role_all = a.role
where function_all = (select function_team from team_kpis where function_team=function_all group by function_team)


/*
FROM team_kpis as b
LEFT JOIN role_kpis as a
ON team_kpi = role_kpi_selected
WHERE role_kpi_selected not in 
    (select role_all FROM gather_all_kpis 
    where function_team_kpi = function_all
    AND team_kpi <> role_kpi_selected
    group by role_all)
AND function_team_kpi IS NOT NULL

GROUP BY
role, team_kpi

/*
SELECT 
    function_all,
    role_all,
    role_kpi_selected,
    team_kpi,
    role,
    role_all,
    CASE 
        WHEN function_all =function_team_kpi --role_kpi_selected = team_kpi
        AND role <> role_all
        THEN 1
        ELSE 0
        END AS pullin,
    
FROM team_kpis AS team_kpis
LEFT JOIN role_kpis AS role_kpis
    ON role_kpi_selected = team_kpi
LEFT JOIN gather_all_kpis as gather_all
    ON gather_all.function_all = team_kpis.function_team_kpi
GROUP BY
    function_all,
    function_team_kpi,
    first_name,
    gather_all.role_all,
    role_kpi_selected,
    team_kpi,
    role_kpi_selected ,
    role

   */