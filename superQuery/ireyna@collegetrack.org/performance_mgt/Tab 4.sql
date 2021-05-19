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
    kpi_all AS team_kpi
    
FROM gather_all_kpis

GROUP BY 
    function_all,
    kpi_all
),

role_kpis AS (
SELECT 
    role_all,
    kpi_all AS role_kpi

FROM gather_all_kpis

GROUP BY 
    role_all,
    kpi_all
)
SELECT 
    team_kpis.function,
    role_kpi,
    CASE 
        WHEN role_kpi <> team_kpi
        THEN "open kpi"
    ELSE role_kpi
    END AS test
    
FROM team_kpis AS team_kpis
LEFT JOIN role_kpis AS role_kpis
    ON team_kpi = role_kpi