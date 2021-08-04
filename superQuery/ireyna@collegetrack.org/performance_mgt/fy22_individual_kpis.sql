
/*
CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_individual_kpis`
OPTIONS
    (
    description= "This table pulls in targets submitted by staff using the Individual KPI Target submission form"
    )
AS
*/

WITH
prep_kpis AS (
SELECT * EXCEPT(enter_your_college_track_email_address,enter_the_target_percent_kpi_list,great_select_your_name,op_rename_role_column_for_mapping),
    enter_your_college_track_email_address AS email_address,
    great_select_your_name AS full_name,
    op_rename_role_column_for_mapping AS team,
    CAST(enter_the_target_percent_kpi_list AS FLOAT64) AS enter_the_target_percent_kpi_list
FROM `data-warehouse-289815.google_sheets.individual_kpi_target` 
WHERE Indicator_Disregard_Entry IS NULL
),

UNION_1A AS (
SELECT 
    email_address,
    full_name,
    team,
    CASE 
        WHEN what_is_the_type_of_target_kpi_list = 'Numeric (but not percent)' AND enter_the_target_numeric_kpi_list IS NOT NULL
        THEN enter_the_target_numeric_kpi_list
    END AS target_fy22_kpi, 
  
    CASE 
        WHEN add_from_your_team_s_kpi_list IS NOT NULL THEN add_from_your_team_s_kpi_list
        ELSE NULL
        END AS fy22_individual_kpi
        
FROM prep_kpis 
GROUP BY 
full_name,
email_address,
team,
target_fy22_kpi,
fy22_individual_kpi
),

UNION_1B AS (
SELECT 
    email_address,
    full_name,
    team,
    CASE
    WHEN what_is_the_type_of_target_kpi_list = 'Percent' AND enter_the_target_percent_kpi_list IS NOT NULL
        THEN enter_the_target_percent_kpi_list
    END AS target_fy22_kpi, 
    CASE 
        WHEN add_from_your_team_s_kpi_list IS NOT NULL THEN add_from_your_team_s_kpi_list
        ELSE NULL
        END AS fy22_individual_kpi
        

FROM prep_kpis
GROUP BY 
full_name,
email_address,
team,
target_fy22_kpi,
fy22_individual_kpi
    ),


UNION_2 AS (
SELECT 
    email_address,
    full_name,
    team,
    CASE 
        WHEN enter_the_target_percent_kpi_list_2 IS NOT NULL THEN enter_the_target_numeric_kpi_list
        ELSE NULL
    END AS target_fy22_kpi, 
  
    CASE 
       WHEN select_a_kpi_from_the_dropdown_2 IS NOT NULL THEN select_a_kpi_from_the_dropdown_2
       ELSE NULL
    END AS fy22_individual_kpi
    
FROM prep_kpis     
GROUP BY 
full_name,
email_address,
team,
target_fy22_kpi,
fy22_individual_kpi
),
UNION_3 AS (
SELECT 
    email_address,
    full_name,
    team,
    CASE 
        WHEN enter_the_target_percent_kpi_list_3 IS NOT NULL THEN enter_the_target_percent_kpi_list_3
        ELSE NULL
    END AS target_fy22_kpi, 
  
    CASE 
       WHEN select_a_kpi_from_the_dropdown_3 IS NOT NULL THEN select_a_kpi_from_the_dropdown_3
       ELSE NULL
    END AS fy22_individual_kpi
    
FROM prep_kpis  
GROUP BY 
full_name,
email_address,
team,
target_fy22_kpi,
fy22_individual_kpi
),       

UNION_4 AS (
SELECT 
    email_address,
    full_name,
    team,
    CASE 
        WHEN enter_the_target_percent_kpi_list_4 IS NOT NULL THEN enter_the_target_percent_kpi_list_4
        ELSE NULL
    END AS target_fy22_kpi, 
  
    CASE 
       WHEN select_a_kpi_from_the_dropdown_4 IS NOT NULL THEN select_a_kpi_from_the_dropdown_4
       ELSE NULL
    END AS fy22_individual_kpi
    
FROM prep_kpis 
GROUP BY 
full_name,
email_address,
team,
target_fy22_kpi,
fy22_individual_kpi
),

UNION_5 AS (
SELECT 
    email_address,
    full_name,
    team,
    CASE 
      WHEN enter_the_target_percent_self_created IS NOT NULL THEN enter_the_target_percent_self_created
      WHEN enter_the_target_numeric_self_created IS NOT NULL THEN enter_the_target_numeric_self_created
    ELSE NULL
    END AS target_fy22_kpi, 
  
    CASE 
      WHEN what_will_your_self_created_kpi_be_this_year_ IS NOT NULL THEN what_will_your_self_created_kpi_be_this_year_
       ELSE NULL
    END AS fy22_individual_kpi
    
FROM prep_kpis
GROUP BY 
full_name,
email_address,
team,
target_fy22_kpi,
fy22_individual_kpi
),

UNION_6 AS (
SELECT 
    email_address,
    full_name,
    team,
    CASE 
        WHEN what_is_the_type_of_target_kpi_list = "I am not adding another KPI from my team's list" THEN 0 
        WHEN what_is_the_type_of_target_self_created = "I am not adding a self-created KPI" THEN 0 
        ELSE NULL
    END AS target_fy22_kpi,

    CASE
        WHEN enter_the_target_percent_kpi_list IS NULL
        THEN 'opting out' 
        WHEN enter_the_target_numeric_kpi_list IS NULL 
        THEN 'opting out' 
        WHEN enter_the_target_percent_kpi_list_2 IS NULL 
        THEN 'opting out' 
        WHEN enter_the_target_percent_kpi_list_3 IS NULL 
        THEN 'opting out'
        WHEN enter_the_target_percent_kpi_list_4 IS NULL
        THEN 'opting out'
  
        END AS fy22_individual_kpi

FROM prep_kpis  
GROUP BY 
full_name,
email_address,
team,
target_fy22_kpi,
fy22_individual_kpi
),

UNION_EVERYTHING AS (

SELECT *
FROM UNION_1A
UNION ALL

SELECT *
FROM UNION_1B
UNION ALL

SELECT *
FROM UNION_2
UNION ALL

SELECT *
FROM UNION_3
UNION ALL

SELECT *
FROM UNION_4
UNION ALL

SELECT *
FROM UNION_5
UNION ALL

SELECT *
FROM UNION_6
)
SELECT 
full_name,
email_address,
team,
target_fy22_kpi,
fy22_individual_kpi
FROM union_everything
GROUP BY
full_name,
email_address,
team,
target_fy22_kpi,
fy22_individual_kpi