WITH gather_data AS
(   
    SELECT  
    contact_id,
    college_track_status_c,
    region_short,
    site_short,
    high_school_graduating_class_c,
    Ethnic_background_c,
    Gender_c,
    current_cc_advisor_2_c
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c = '15A'
)

    SELECT
    *
    FROM gather_data

    
    
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