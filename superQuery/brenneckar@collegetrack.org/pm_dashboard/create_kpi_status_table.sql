WITH gather_data AS (
  SELECT
    KPI_Selection.*,
    CASE
      WHEN KPI_Target.select_role IS NOT NULL THEN true
      ELSE false
    END AS target_submitted,
    CASE
      WHEN enter_the_target_numeric_ IS NOT NULL THEN enter_the_target_numeric_
      WHEN enter_the_target_percent_ iS NOT NULL THEN enter_the_target_percent_ --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_
      ELSE NULL
    END AS target,
    CASE
      WHEN site_kpi = 0 THEN NULL
      ELSE site_kpi
    END AS site
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
  target_submitted = true