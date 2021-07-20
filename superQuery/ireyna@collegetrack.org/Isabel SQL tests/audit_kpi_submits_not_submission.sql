WITH gather_all_kpis AS (
SELECT function, role, kpis_by_role
FROM `data-studio-260217.performance_mgt.role_kpi_selection` #clean list of KPIs by Role
ORDER BY function, role
),

gather_unique_function_role AS (
SELECT DISTINCT function function, role 
FROM gather_all_kpis
)

--create_list_of_unseleted_kpis_by_role AS (
SELECT GAFR.team_kpi, GAFR.select_role, GAK.kpis_by_role
FROM gather_all_kpis GAK
LEFT JOIN `data-warehouse-289815.google_sheets.audit_kpi_target_submissions` GAFR  #gsheet kpi target submissions
ON GAK.role = GAFR.select_role 
--WHERE GAFR.select_role != GAK.role
WHERE submission_id IS NULL
GROUP BY team_kpi,select_role,kpis_by_role