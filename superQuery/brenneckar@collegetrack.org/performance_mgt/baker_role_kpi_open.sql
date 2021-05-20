WITH gather_all_kpis AS (
SELECT function, role, kpi
FROM `data-studio-260217.performance_mgt.role_kpi_selection`
),

gather_unique_kpis AS (
SELECT role 
FROM gather_all_kpis
WHERE role NOT IN (SELECT role FROM gather_all_kpis)
)

SELECT *
FROM gather_unique_kpis