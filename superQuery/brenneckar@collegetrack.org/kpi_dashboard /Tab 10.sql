SELECT site_short, SUM(student_count) AS student_count, SUM(completed_survey_count) AS completed_survey_count
FROM `data-studio-260217.surveys.fy21_hs_survey_completion`
GROUP BY site_short