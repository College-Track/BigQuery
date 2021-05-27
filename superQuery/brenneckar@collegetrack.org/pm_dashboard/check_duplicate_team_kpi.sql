WITH create_count_of_kpis AS (SELECT team_kpi, region_kpi, site_kpi, select_kpi, COUNT(*) AS kpi_count
FROM `data-warehouse-289815.google_sheets.team_kpi_target`
GROUP BY team_kpi, region_kpi, site_kpi, select_kpi
)

SELECT team_kpi, region_kpi, site_kpi, select_kpi
FROM create_count_of_kpis
WHERE kpi_count = 1