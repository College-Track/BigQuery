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
        END AS fy22_individual_kpi,
    CASE 
        WHEN what_is_the_type_of_target_kpi_list IS NOT NULL 
        THEN what_is_the_type_of_target_kpi_list
        WHEN what_is_the_type_of_target_self_created IS NOT NULL
        THEN what_is_the_type_of_target_self_created
    END AS fy22_type_of_target
        
FROM prep_kpis 

)

UNION_1B AS (
SELECT 
    email_address,
    full_name,
    team,
    CASE
    WHEN what_is_the_type_of_target_kpi_list = 'Percent' AND enter_the_target_percent_kpi_list IS NOT NULL
        THEN enter_the_target_percent_kpi_list
    WHEN what_is_the_type_of_target_kpi_list = 'Numeric (but not percent)' AND enter_the_target_numeric_kpi_list IS NOT NULL
        THEN enter_the_target_percent_kpi_list
    END AS target_fy22_kpi, 
    CASE 
        WHEN add_from_your_team_s_kpi_list IS NOT NULL THEN add_from_your_team_s_kpi_list
        ELSE NULL
        END AS fy22_individual_kpi,
    CASE 
        WHEN what_is_the_type_of_target_kpi_list IS NOT NULL 
        THEN what_is_the_type_of_target_kpi_list
        #WHEN what_is_the_type_of_target_self_created IS NOT NULL
        #THEN what_is_the_type_of_target_self_created
    END AS fy22_type_of_target
        

FROM prep_kpis
    ),


--UNION_2 AS (
SELECT 
    email_address,
    full_name,
    team,
    CASE 
        WHEN enter_the_target_percent_kpi_list_2 IS NOT NULL THEN enter_the_target_percent_kpi_list_2
        ELSE NULL
    END AS target_fy22_kpi, 
  
    CASE 
       WHEN select_a_kpi_from_the_dropdown_2 IS NOT NULL THEN select_a_kpi_from_the_dropdown_2
       ELSE NULL
    END AS fy22_individual_kpi,
    CASE 
        WHEN what_is_the_type_of_target_kpi_list IS NOT NULL 
        THEN what_is_the_type_of_target_kpi_list
        #WHEN what_is_the_type_of_target_self_created IS NOT NULL
        #THEN what_is_the_type_of_target_self_created
    END AS fy22_type_of_target
    
FROM prep_kpis  