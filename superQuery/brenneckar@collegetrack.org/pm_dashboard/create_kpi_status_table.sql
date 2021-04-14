WITH gather_data AS (
  SELECT
    KPI_Selection.*,
    CASE
      WHEN KPI_Target.select_role IS NOT NULL THEN true
      ELSE false
    END AS target_submitted,
  FROM
    `data-studio-260217.performance_mgt.role_kpi_selection` KPI_Selection
    LEFT JOIN `data-warehouse-289815.google_sheets.team_kpi_target` KPI_Target ON KPI_Target.team_kpi = REPLACE(KPI_Selection.function, ' ', '_')
    AND KPI_Target.select_role = KPI_Selection.role
    AND KPI_Target.select_kpi = KPI_Selection.KPI
)
SELECT
  *
FROM
  gather_data
WHERE
  kpi = '-Strategy Team satisfaction: % of strategy team members that agree or strongly agree that the connection between annual planning & budgeting is an effective process and tool for setting annual priorities (in service of improved outcomes across the org).'