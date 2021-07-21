/*
CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.audit_kpi_weird_targets`
OPTIONS
    (
    description= "This table pulls in targets that do not make sense for a numeric, percent or T/F target"
    )
AS 
*/


SELECT
    staff_list.first_name,
    staff_list.last_name,
    staff_list.team,
    staff_list.program_area,
    staff_list.site,
    staff_list.region,
    what_is_the_type_of_target_,
    add_from_your_team_s_kpi_list,
    what_will_your_self_created_kpi_be_this_year_,
    CASE
      WHEN enter_the_target_numeric_kpi_list IS NOT NULL THEN enter_the_target_numeric_kpi_list
      WHEN enter_the_target_percent_kpi_list iS NOT NULL THEN enter_the_target_percent_kpi_list
      --WHEN what_is_the_type_of_target_kpi_list = "Goal is met" THEN 1 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22_kpi_list,
    CASE
      WHEN enter_the_target_percent_self_created IS NOT NULL THEN enter_the_target_percent_self_created
      WHEN enter_the_target_numeric_self_created iS NOT NULL THEN enter_the_target_numeric_self_created
      --WHEN what_is_the_type_of_target_kpi_list = "Goal is met" THEN 1 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22_kpi_self_created,
    
FROM `data-warehouse-289815.google_sheets.staff_list` AS staff_list
LEFT JOIN `data-warehouse-289815.google_sheets.individual_kpi_target` AS kpi_targets_submitted
    ON kpi_targets_submitted.enter_your_college_track_email_address = staff_list.email_address