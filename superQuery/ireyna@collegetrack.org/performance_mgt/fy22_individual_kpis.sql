/*
CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_individual_kpis`
OPTIONS
    (
    description= "This table pulls in targets submitted by staff using the Individual KPI Target submission form"
    )
AS
*/
WITH
prep_individual_kpis AS (
SELECT 
    * EXCEPT (response_url,enter_the_target_percent_kpi_list,enter_the_target_numeric_kpi_list,enter_the_target_percent_kpi_list_2,enter_the_target_percent_kpi_list_3),
    CASE 
        WHEN enter_the_target_percent_kpi_list IS NULL 
        THEN 0 
    END AS enter_the_target_percent_kpi_list,
        CASE 
        WHEN enter_the_target_numeric_kpi_list IS NULL 
        THEN 0 
    END AS enter_the_target_numeric_kpi_list,
    CASE 
        WHEN enter_the_target_percent_kpi_list_2 IS NULL 
        THEN 0 
    END AS enter_the_target_percent_kpi_list_2,
        CASE 
        WHEN enter_the_target_percent_kpi_list_3 IS NULL 
        THEN 0 
    END AS enter_the_target_percent_kpi_list_3
 
/*
    CASE
      WHEN enter_the_target_numeric_kpi_list IS NOT NULL THEN enter_the_target_numeric_kpi_list
      WHEN enter_the_target_percent_kpi_list IS NOT NULL THEN enter_the_target_percent_kpi_list
      WHEN what_is_the_type_of_target_kpi_list = "I am not adding another KPI from my team's list" THEN 0 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22_kpi,
    CASE
      WHEN enter_the_target_percent_kpi_list_2 IS NOT NULL THEN enter_the_target_percent_kpi_list_2
      ELSE NULL
    END AS target_fy22_kpi,
    CASE
      WHEN enter_the_target_percent_kpi_list_3 IS NOT NULL THEN enter_the_target_percent_kpi_list_3
      ELSE NULL
    END AS target_fy22_kpi,
    CASE
      WHEN enter_the_target_percent_self_created IS NOT NULL THEN enter_the_target_percent_self_created
      WHEN enter_the_target_numeric_self_created IS NOT NULL THEN enter_the_target_numeric_self_created
      WHEN what_is_the_type_of_target_self_created = "I am not adding a self-created KPI" THEN 0 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22_kpi
*/    
    
FROM`data-warehouse-289815.google_sheets.individual_kpi_target` AS indiv_kpis
WHERE Indicator_Disregard_Entry IS NULL
)
SELECT 
* EXCEPT (enter_the_target_numeric_kpi_list,enter_the_target_percent_kpi_list,enter_the_target_percent_kpi_list_2,enter_the_target_percent_kpi_list_3),
 CASE
      WHEN enter_the_target_numeric_kpi_list <> 0 THEN enter_the_target_numeric_kpi_list
      WHEN enter_the_target_percent_kpi_list <> 0 THEN enter_the_target_percent_kpi_list
      WHEN what_is_the_type_of_target_kpi_list = "I am not adding another KPI from my team's list" THEN 0 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      WHEN enter_the_target_percent_kpi_list_2 <> 0 THEN enter_the_target_percent_kpi_list_2
      WHEN enter_the_target_percent_kpi_list_3 <> 0 THEN enter_the_target_percent_kpi_list_3
      WHEN enter_the_target_percent_self_created <> 0 THEN enter_the_target_percent_self_created
      WHEN enter_the_target_numeric_self_created <> 0 THEN enter_the_target_numeric_self_created
      WHEN what_is_the_type_of_target_self_created = "I am not adding a self-created KPI" THEN 0 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22_kpi,
CASE 
    WHEN add_from_your_team_s_kpi_list IS NOT NULL THEN add_from_your_team_s_kpi_list
    WHEN what_will_your_self_created_kpi_be_this_year_ IS NOT NULL THEN what_will_your_self_created_kpi_be_this_year_
    WHEN select_a_kpi_from_the_dropdown IS NOT NULL THEN select_a_kpi_from_the_dropdown
    WHEN select_a_kpi_from_the_dropdown_2 IS NOT NULL THEN select_a_kpi_from_the_dropdown_2
    WHEN select_a_kpi_from_the_dropdown_3 IS NOT NULL THEN select_a_kpi_from_the_dropdown_3
    WHEN select_a_kpi_from_the_dropdown_4 IS NOT NULL THEN select_a_kpi_from_the_dropdown_4
    ELSE NULL
END AS fy22_individual_kpi

FROM prep_individual_kpis
