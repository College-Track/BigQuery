SELECT SELECTION.*,
KPI.kpi_id
FROM `data-studio-260217.performance_mgt.role_kpi_selection` SELECTION
LEFT JOIN `data-studio-260217.performance_mgt.kpi_table` KPI ON KPI.kpi = SELECTION.kpi