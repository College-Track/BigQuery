WITH create_count_of_kpis AS (
  SELECT
    team_kpi,
    region_kpi,
    site_kpi,
    select_kpi,
    COUNT(*) AS kpi_count
  FROM
    `data-warehouse-289815.google_sheets.team_kpi_target`
  GROUP BY
    team_kpi,
    region_kpi,
    site_kpi,
    select_kpi
),
gather_duplicate_kpis AS (
  SELECT
    team_kpi,
    region_kpi,
    site_kpi,
    select_kpi
  FROM
    create_count_of_kpis
  WHERE
    kpi_count >1
)
SELECT
  GDK.*,
  TKT.email_kpi
FROM
  gather_duplicate_kpis GDK
  LEFT JOIN `data-warehouse-289815.google_sheets.team_kpi_target` TKT ON TKT.team_kpi = GDK.team_kpi
  AND TKT.region_kpi = GDK.region_kpi
  AND TKT.site_kpi = GDK.site_kpi
  AND TKT.select_kpi = GDK.select_kpi