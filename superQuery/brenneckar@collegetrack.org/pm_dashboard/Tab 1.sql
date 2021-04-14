SELECT KPI_Selection.*
FROM `data-studio-260217.performance_mgt.role_kpi_selection` KPI_Selection
LEFT JOIN `data-warehouse-289815.google_sheets.team_kpi_target` KPI_Target ON KPI_Target.select_your_team_function = KPI_Selection.function