WITH gather_all_kpis AS (
SELECT function, role, kpis_by_role
FROM `data-studio-260217.performance_mgt.role_kpi_selection` #clean list of KPIs by Role
ORDER BY function, role
),

gather_unique_function_role AS (
SELECT DISTINCT function function, role 
FROM gather_all_kpis
)


SELECT all_kpis.*, kpis_submitted.*
FROM gather_all_kpis AS all_kpis
LEFT JOIN `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS kpis_submitted
    ON all_kpis.kpis_by_role = kpis_submitted.role