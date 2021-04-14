select 
submission_id,
enter_the_target_non_numeric_ AS KPI__target_str,
enter_the_target_numeric_ AS KPI__target_num,
enter_the_target_percent_ AS KPI__target_perc
from `data-warehouse-289815.google_sheets.team_kpi_target`
unpivot
(
  value
  for col in (enter_the_target_non_numeric_, enter_the_target_numeric_, enter_the_target_percent_)
) un
order by submission_id