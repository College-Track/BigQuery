WITH gather_all_kpis AS (
SELECT function, role, kpi
FROM `data-studio-260217.performance_mgt.role_kpi_selection`
ORDER BY function, role
)


SELECT GAK_ALL.function, GAK_ALL.role, GAK.kpi
FROM gather_all_kpis GAK_ALL
LEFT JOIN gather_all_kpis GAK ON GAK_ALL.function = GAK_ALL.function
WHERE GAK_ALL.role != GAK.role AND GAK_ALL.kpi != GAK.kpi
ORDER BY GAK_ALL.functon, GAK_ALL.role