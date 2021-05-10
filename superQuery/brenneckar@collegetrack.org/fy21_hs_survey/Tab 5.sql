WITH gather_completed_survey_data AS (
  SELECT
    -- site_short,
    -- high_school_graduating_class_c,
    -- Most_Recent_GPA_Cumulative_bucket,
    -- Ethnic_background_c,
    -- Gender_c,
    count(contact_Id) as completed_survey_count
  FROM
    `data-studio-260217.surveys.fy21_hs_survey_wide_prepped`
--   GROUP BY
--     site_short,
--     high_school_graduating_class_c,
--     Most_Recent_GPA_Cumulative_bucket,
--     Ethnic_background_c,
--     Gender_c
)

SELECT *
FROM gather_completed_survey_data