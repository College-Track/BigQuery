WITH calc_score AS (
SELECT 
    site_short,
    sub_section, 
    `data-studio-260217.surveys.determine_positive_answers`(answer) AS answer_score,

FROM `data-studio-260217.surveys.fy21_hs_survey_long_prepped`
)

SELECT sub_section,
avg(answer_score)
FROM calc_score
GROUP BY sub_section