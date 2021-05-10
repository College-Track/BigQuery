WITH gather_data AS(
  SELECT
    HSCRP.site_short,
    HSCRP.high_school_graduating_class_c,
    HSCRP.Most_Recent_GPA_Cumulative_bucket,
    HSCRP.Ethnic_background_c,
    HSCRP.Gender_c,
    HSCRP.contact_id,
    CASE
      WHEN HSWP.contact_id IS NOT NULL THEN 1
      ELSE 0
    END AS completed_survey_indicator -- COUNT(Contact_Id) as student_count
  FROM
    `data-studio-260217.surveys.fy21_hs_survey_completion_reporting_group` HSCRP
    LEFT JOIN `data-studio-260217.surveys.fy21_hs_survey_wide_prepped` HSWP ON HSWP.contact_id = HSCRP.contact_id --   GROUP BY
    --     site_short,
    --     high_school_graduating_class_c,
    --     Most_Recent_GPA_Cumulative_bucket,
    --     Ethnic_background_c,
    --     Gender_c
    -- ),
    )
  SELECT
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket,
    Ethnic_background_c,
    Gender_c,
    COUNT(contact_id) AS student_count,
    SUM(completed_survey_indicator) AS completed_survey_count
  FROM
    gather_data
  GROUP BY
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket,
    Ethnic_background_c,
    Gender_c 
    
    -- gather_completed_survey_data AS (
    --   SELECT
    --     site_short,
    --     high_school_graduating_class_c,
    --     Most_Recent_GPA_Cumulative_bucket,
    --     Ethnic_background_c,
    --     Gender_c,
    --     count(contact_Id) as completed_survey_count
    --   FROM
    --     `data-studio-260217.surveys.fy21_hs_survey_wide_prepped`
    --   GROUP BY
    --     site_short,
    --     high_school_graduating_class_c,
    --     Most_Recent_GPA_Cumulative_bucket,
    --     Ethnic_background_c,
    --     Gender_c
    -- ),
    -- join_data AS (
    --   SELECT
    --     GD.*,
    --     gather_completed_survey_data.completed_survey_count
    --   FROM
    --     gather_data GD
    --     LEFT JOIN gather_completed_survey_data ON gather_completed_survey_data.site_short = GD.site_short
    --     AND gather_completed_survey_data.high_school_graduating_class_c = GD.high_school_graduating_class_c
    --     AND gather_completed_survey_data.Most_Recent_GPA_Cumulative_bucket = GD.Most_Recent_GPA_Cumulative_bucket
    --     AND gather_completed_survey_data.Ethnic_background_c = GD.Ethnic_background_c
    --     AND gather_completed_survey_data.Gender_c = GD.Gender_c
    -- )
    -- SELECT
    --   *
    -- FROM
    --   join_data