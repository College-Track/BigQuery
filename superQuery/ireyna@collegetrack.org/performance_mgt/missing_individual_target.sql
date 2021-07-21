
SELECT
    staff_list.first_name,
    staff_list.last_name,
    staff_list.team,
    staff_list.program_area,
    staff_list.site,
    staff_list.region,
    what_is_the_type_of_target_,
    add_from_your_team_s_kpi_list,
    CASE
      WHEN enter_the_target_numeric_kpi_list IS NOT NULL THEN enter_the_target_numeric_kpi_list
      WHEN enter_the_target_percent_kpi_list IS NOT NULL THEN enter_the_target_percent_kpi_list
      WHEN what_is_the_type_of_target_kpi_list = "I am not adding another KPI from my team's list" THEN 0 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22_kpi_list,
    what_will_your_self_created_kpi_be_this_year_,
    CASE
      WHEN enter_the_target_percent_self_created IS NOT NULL THEN enter_the_target_percent_self_created
      WHEN enter_the_target_numeric_self_created IS NOT NULL THEN enter_the_target_numeric_self_created
      WHEN what_is_the_type_of_target_self_created = "I am not adding a self-created KPI" THEN 0 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22_kpi_self_created,
    

FROM`data-warehouse-289815.google_sheets.individual_kpi_target` AS kpi_targets_submitted