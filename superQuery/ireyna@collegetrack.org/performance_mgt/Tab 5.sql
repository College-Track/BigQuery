WITH 

gather_all_kpis AS (
SELECT
    first_name,
    last_name,
    function,
    role,
    kpi AS team_kpi
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi`
)
--kpi_by_team AS (
SELECT 
    a.function,
    a.role,
    kpi
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` as a
LEFT JOIN gather_all_kpis AS b ON b.function = a.function --AND team_kpi = kpi
WHERE a.role <> b.role
GROUP BY 
    function,kpi,role