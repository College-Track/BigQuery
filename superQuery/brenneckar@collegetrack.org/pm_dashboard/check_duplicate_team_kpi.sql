SELECT team_kpi, region_kpi, site_kpi, select_kpi, COUNT(*)
FROM `data-warehouse-289815.google_sheets.team_kpi_target`
GROUP BY team_kpi, region_kpi, site_kpi, select_kpi