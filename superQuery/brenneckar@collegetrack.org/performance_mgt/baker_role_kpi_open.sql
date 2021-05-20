WITH gather_all_kpis AS (
SELECT function, role, kpi
FROM `data-studio-260217.performance_mgt.role_kpi_selection`
)

SELECT *
FROM gather_all_kpis