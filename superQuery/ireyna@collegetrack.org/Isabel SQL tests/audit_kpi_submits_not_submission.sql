WITH gather_all_kpis AS (
SELECT function, role, kpis_by_role
FROM `data-studio-260217.performance_mgt.role_kpi_selection`
ORDER BY function, role
)

--gather_unique_function_role AS (
SELECT DISTINCT function function, role 
FROM gather_all_kpis