SELECT COUNT(DISTINCT Ethnic_background_c), COUNT(distinct Gender_c)
FROM `data-studio-260217.kpi_dashboard_dev.team_kpi_table`
WHERE site_short = 'Watts'