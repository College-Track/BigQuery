
CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_kpi_audit_no_individual_kpi`
OPTIONS
    (
    description= "This table pulls in staff that have not submitted using the Individual KPI Form"
    )
AS 


WITH 

submitted_individual_kpis AS (
SELECT
    LOWER(enter_your_college_track_email_address) AS enter_your_college_track_email_address,
    great_select_your_name,
    what_is_the_type_of_target_,
    add_from_your_team_s_kpi_list,
    thanks_select_your_team_program_area,
    CASE
      WHEN enter_the_target_numeric_kpi_list IS NOT NULL THEN enter_the_target_numeric_kpi_list
      WHEN enter_the_target_percent_kpi_list IS NOT NULL THEN enter_the_target_percent_kpi_list
      WHEN what_is_the_type_of_target_kpi_list = "I am not adding another KPI from my team's list" THEN 0 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22_kpi_list_1,
    CASE
      WHEN enter_the_target_percent_kpi_list_2 IS NOT NULL THEN enter_the_target_percent_kpi_list_2
      ELSE NULL
    END AS target_fy22_kpi_list_2,
    CASE
      WHEN enter_the_target_percent_kpi_list_3 IS NOT NULL THEN enter_the_target_percent_kpi_list_3
      ELSE NULL
    END AS target_fy22_kpi_list_3,
    what_will_your_self_created_kpi_be_this_year_,
    CASE
      WHEN enter_the_target_percent_self_created IS NOT NULL THEN enter_the_target_percent_self_created
      WHEN enter_the_target_numeric_self_created IS NOT NULL THEN enter_the_target_numeric_self_created
      WHEN what_is_the_type_of_target_self_created = "I am not adding a self-created KPI" THEN 0 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22_kpi_self_created
FROM`data-warehouse-289815.google_sheets.individual_kpi_target` AS kpi_targets_submitted
),

--Identify missing KPI submission using full name
no_individual_kpi_full_name AS (

SELECT 
    staff_list.first_name,
    staff_list.last_name,
    staff_list.full_name,
    great_select_your_name,
    staff_list.email_address,
    enter_your_college_track_email_address,
    thanks_select_your_team_program_area,
    staff_list.team,
    staff_list.program_area,
    staff_list.site,
    staff_list.region
FROM  `data-warehouse-289815.google_sheets.staff_list` staff_list
LEFT JOIN  submitted_individual_kpis 
    ON program_area = thanks_select_your_team_program_area
    AND full_name = great_select_your_name
WHERE great_select_your_name IS NULL
),

--Identify missing KPI submission using email address
no_individual_kpi_email AS (
SELECT 
    staff_list.first_name,
    staff_list.last_name,
    staff_list.full_name,
    great_select_your_name,
    staff_list.email_address,
    enter_your_college_track_email_address,
    thanks_select_your_team_program_area,
    staff_list.team,
    staff_list.program_area,
    staff_list.site,
    staff_list.region
FROM  `data-warehouse-289815.google_sheets.staff_list` staff_list
LEFT JOIN  submitted_individual_kpis
    ON email_address = enter_your_college_track_email_address
WHERE enter_your_college_track_email_address IS NULL
AND full_name  IN (SELECT full_name FROM no_individual_kpi_full_name) --if staff member is NOT listed as missing in no_individual_kpi_full_name table, then do NOT pull them in as missing here
)

SELECT * 
FROM no_individual_kpi_email 

UNION ALL

SELECT *
FROM no_individual_kpi_full_name