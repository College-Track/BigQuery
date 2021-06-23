 SELECT
    team_kpi,
    region_kpi,
    site_kpi,
    select_role,
    select_kpi,
    what_is_the_type_of_target_,
    CASE
      
      WHEN KPI_Target.select_role IS NOT NULL THEN "Submitted"
    --   WHEN site_kpi IN ("Sacramento", "Denver", "Watts") AND select_kpi = '% of students graduating from college within 6 years' THEN "Not Required"
      ELSE "Not Submitted"
    END AS target_submitted,
    CASE
      WHEN enter_the_target_numeric_ IS NOT NULL THEN enter_the_target_numeric_
      WHEN enter_the_target_percent_ iS NOT NULL THEN enter_the_target_percent_
      WHEN what_is_the_type_of_target_ = "Goal is met" THEN 1 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_
      ELSE NULL
    END AS target_fy22,
  FROM
    `data-warehouse-289815.google_sheets.team_kpi_target` KPI_Target
    WHERE email_kpi != 'test@collegetrack.org'