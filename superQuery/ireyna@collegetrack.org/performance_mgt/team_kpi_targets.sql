SELECT
submission_id,
enter_the_target_non_numeric_, 
enter_the_target_numeric_, 
enter_the_target_percent_,

(
    select enter_the_target_non_numeric_ as value1 from `data-warehouse-289815.google_sheets.team_kpi_target`
    union
    select enter_the_target_numeric_ as value2 from `data-warehouse-289815.google_sheets.team_kpi_target`
    union
    select enter_the_target_percent_ as value3 from `data-warehouse-289815.google_sheets.team_kpi_target`
) tt 
where value is not null
from `data-warehouse-289815.google_sheets.team_kpi_target`