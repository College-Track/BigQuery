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
    function_all,
    role_all,
    kpi_all AS team_kpi
    
FROM gather_all_kpis

GROUP BY 
    function_all,
    kpi_all,
    role_all
),

role_kpis AS (
SELECT 
    kpi_all AS role_kpi_selected,
    role_all AS role,
    function_all AS roles_team

FROM gather_all_kpis 

GROUP BY 
    kpi_all,
    function_all,
    role
    
)
--select_open_kpi AS (
SELECT 
    role,
    role_kpi_selected,
    CASE 
        WHEN roles_team = function_all
        AND role <> role_all
        THEN 'should be open kpi'
    end as open_q,
    team_kpi
    
FROM team_kpis
FULL JOIN role_kpis AS a
ON function_all = roles_team

WHERE team_kpi NOT IN (select b.role_kpi_selected from role_kpis AS b where a.roles_team = b.roles_team)
/*)
SELECT 
    role,
    open_q,
    role_kpi_selected

from select_open_kpi

GROUP BY 
    role, open_q, role_kpi_selected
*/
