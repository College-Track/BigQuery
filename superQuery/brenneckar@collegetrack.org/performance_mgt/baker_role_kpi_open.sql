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

SELECT CLUK.function, CLUK.role, CLUK.kpi, GAK.kpi
FROM create_list_of_unseleted_kpis CLUK
LEFT JOIN gather_all_kpis GAK ON GAK.role = CLUK.role AND GAK.kpi = CLUK.kpi
WHERE CLUK.role = 'Talent Acquisition Manager'