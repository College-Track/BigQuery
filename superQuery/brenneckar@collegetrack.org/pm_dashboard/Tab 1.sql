SELECT
  KPI_Selection.*,
  CASE WHEN KPI_Target.select_role IS NOT NULL THEN true
  ELSE false
  END AS target_submitted
FROM
  `data-studio-260217.performance_mgt.role_kpi_selection` KPI_Selection
  LEFT JOIN `data-warehouse-289815.google_sheets.team_kpi_target` KPI_Target ON 
  KPI_Target.select_your_team_function = KPI_Selection.function AND KPI_Target.select_role = KPI_Selection.role AND KPI_Target.select_kpi = KPI_Selection.KPI
  WHERE target_submitted = true