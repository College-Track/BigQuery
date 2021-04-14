/*
CREATE OR REPLACE TABLE `data-warehouse-289815.performance_mgt.team_kpi_targets`
OPTIONS
    (
    description="Filtered table to house CT Team KPIs and respective Targets"
    )
AS
*/
SELECT 
submission_id,
select_your_team_function AS Team,
team_role,
select_role AS Role,
site AS Site,
select_kpi AS KPI,
enter_the_target_non_numeric_ AS KPI_str,
enter_the_target_numeric_ AS KPI_num,
enter_the_target_percent_ AS KPI_perc

#select_your_site
FROM `data-warehouse-289815.google_sheets.team_kpi_target`
LIMIT 10