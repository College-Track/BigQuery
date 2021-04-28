WITH gather_data AS(
  SELECT
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket,
    Ethnic_background_c,
    Gender_c,
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
    Most_Recent_GPA_Cumulative_bucket,
        Ethnic_background_c,
    Gender_c
),
gather_completed_survey_data AS (
  SELECT
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket,
    Ethnic_background_c,
    Gender_c,
    count(contact_Id) as completed_survey_count
  FROM
    `data-studio-260217.surveys.fy21_hs_survey_wide_prepped`
  GROUP BY
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket,
        Ethnic_background_c,
    Gender_c
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
  SUM(student_count)
FROM
  gather_data