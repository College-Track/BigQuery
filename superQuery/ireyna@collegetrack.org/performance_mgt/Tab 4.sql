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
    kpi AS role_kpi_selected,
    function
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` 
GROUP BY 
    role,
    kpi,
    function
),
joined_kpis AS (
SELECT a.*, b.*
FROM team_kpis AS a
FULL JOIN role_kpis AS b
ON function_team = b.function
WHERE role_kpi_selected <> team_kpi
GROUP BY 
    function_team,
    team_kpi,
    role_kpi_selected,
    function,
    role
)
SELECT role,team_kpi,
 role_kpi_selected NOT IN (SELECT team_kpi FROM joined_kpis where function_team = function and role_kpi_selected <> team_kpi group by team_kpi) AS team_kpi
from joined_kpis
group by role, team_kpi