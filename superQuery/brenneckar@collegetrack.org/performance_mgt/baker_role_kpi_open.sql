WITH gather_all_kpis AS (
SELECT function, role, kpi
FROM `data-studio-260217.performance_mgt.role_kpi_selection`
),

gather_unique_function_role AS (
SELECT DISTINCT function function, role 
FROM gather_all_kpis
)
SELECT GAFR.function, GAFR.role, GAK.kpi, GAK.role
FROM gather_unique_function_role GAFR
LEFT JOIN gather_all_kpis GAK ON GAK.function = GAFR.function
WHERE GAFR.role != GAK.role