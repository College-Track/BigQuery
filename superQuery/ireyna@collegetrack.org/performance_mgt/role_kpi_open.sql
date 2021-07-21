/*
CREATE OR REPLACE TABLE `data-warehouse-289815.performance_mgt.fy22_roles_kpis_open`
OPTIONS
    (
    description="This table lists KPIs available for staff to select based on role during Individual KPI selection phase. If a KPI is on the staff member's team, they can select pre-determined KPIs on their team that was not mapped to their role. "
    )
AS
*/

WITH gather_all_kpis AS (
SELECT function, role, kpi
FROM `data-studio-260217.performance_mgt.role_kpi_selection`
ORDER BY function, role
),

gather_unique_function_role AS (
SELECT DISTINCT function function, role 
FROM gather_all_kpis
), 

create_list_of_unseleted_kpis AS (
SELECT GAFR.function, GAFR.role, GAK.kpi
FROM gather_unique_function_role GAFR
LEFT JOIN gather_all_kpis GAK ON GAK.function = GAFR.function
WHERE GAFR.role != GAK.role
)

SELECT DISTINCT CLUK.function, CLUK.role, CLUK.kpi
FROM create_list_of_unseleted_kpis CLUK
LEFT JOIN gather_all_kpis GAK ON GAK.role = CLUK.role AND GAK.kpi = CLUK.kpi 
WHERE GAK.kpi IS NULL