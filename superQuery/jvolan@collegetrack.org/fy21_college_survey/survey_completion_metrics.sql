CREATE OR REPLACE TABLE `data-studio-260217.surveys.fy21_ps_survey_completion_metrics`
OPTIONS
    (
    description= "fy21 ps survey completion metrics"
    )
AS
WITH student_list_denom AS
(   
    SELECT  
    contact_id,
    College_Track_Status_Name,
    region_short,
    site_short,
    high_school_graduating_class_c,
    Ethnic_background_c,
    Gender_c,
    Current_School_Type_c_degree,
    current_cc_advisor_2_c, 
    CASE
        WHEN completed_ct_2020_21_survey_c = "PS Survey" THEN 1
        Else 0
    END AS took_survey_yn
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c IN ('15A')
    AND Contact_Id NOT IN (
        SELECT
        Contact_c
      FROM
        `data-warehouse-289815.salesforce.contact_pipeline_history_c`
      WHERE
        created_date >= '2021-03-15T22:00:00.000Z'
        AND Name = 'Became Active Post-Secondary'
    )
)

    SELECT
    region_short,
    site_short,
    high_school_graduating_class_c,
    Ethnic_background_c,
    Gender_c,
    Current_School_Type_c_degree,
    sum(took_survey_yn) AS took_survey_count,
    count(Contact_Id) AS student_count
    
    FROM student_list_denom
    GROUP BY
    region_short,
    site_short,
    high_school_graduating_class_c,
    Ethnic_background_c,
    Gender_c,
    Current_School_Type_c_degree
   
    
/*

WITH gather_data AS(
  SELECT
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket,
    COUNT(Contact_Id) as student_count
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    College_Track_Status_c IN ('11A', '12A', '18a')
    AND Contact_Id NOT IN (
      SELECT
        Contact_c
      FROM
        `data-warehouse-289815.salesforce.contact_pipeline_history_c`
      WHERE
        created_date >= '2021-02-17T22:00:00.000Z'
        AND Name = 'Started/Restarted CT HS Program'
    )
  GROUP BY
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket
),
gather_completed_survey_data AS (
  SELECT
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket,
    count(contact_Id) as completed_survey_count
  FROM
    `data-studio-260217.surveys.fy21_hs_survey_wide_prepped`
  GROUP BY
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket
),
join_data AS (
  SELECT
    GD.*,
    gather_completed_survey_data.completed_survey_count
  FROM
    gather_data GD
    LEFT JOIN gather_completed_survey_data ON gather_completed_survey_data.site_short = GD.site_short
    AND gather_completed_survey_data.high_school_graduating_class_c = GD.high_school_graduating_class_c
    AND gather_completed_survey_data.Most_Recent_GPA_Cumulative_bucket = GD.Most_Recent_GPA_Cumulative_bucket
)
SELECT
  *
FROM
  join_data
  */