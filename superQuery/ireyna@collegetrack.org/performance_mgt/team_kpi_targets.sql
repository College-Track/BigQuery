
SELECT 
submission_id,
select_your_team_function AS Team,
select_role AS Role,
site_kpi AS Site,
region_kpi AS Region,
select_kpi AS KPI,
--enter_the_target_non_numeric_ AS KPI__target_str,
enter_the_target_numeric_ AS KPI__target_num,
enter_the_target_percent_ AS KPI__target_perc
/*
CASE 
    WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_
    WHEN (enter_the_target_non_numeric_ IS NULL AND enter_the_target_numeric_ IS NOT NULL) THEN enter_the_target_numeric_
    WHEN (enter_the_target_non_numeric_ IS NULL AND enter_the_target_percent_ IS NOT NULL) THEN enter_the_target_percent_
    
    WHEN enter_the_target_numeric_ IS NOT NULL THEN enter_the_target_numeric_
    WHEN (enter_the_target_numeric_ IS NULL AND enter_the_target_non_numeric_ IS NOT NULL) THEN enter_the_target_non_numeric_
    WHEN (enter_the_target_numeric_ IS NULL AND enter_the_target_percent_ IS NOT NULL) THEN enter_the_target_percent_
    
    WHEN enter_the_target_percent_ IS NOT NULL THEN enter_the_target_percent_
    WHEN (enter_the_target_percent_ IS NULL AND enter_the_target_non_numeric_ IS NOT NULL) THEN enter_the_target_non_numeric_
    WHEN (enter_the_target_percent_ IS NULL AND enter_the_target_numeric_ IS NOT NULL) THEN enter_the_target_numeric_
END AS KPI_target
*/
from 
`data-warehouse-289815.google_sheets.team_kpi_target`