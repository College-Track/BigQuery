WITH calc_score AS (
SELECT 
    site_short,
    section, 
    question,
    `data-studio-260217.surveys.determine_positive_answers`(answer) AS answer_score,

FROM `data-studio-260217.surveys.fy21_hs_survey_long_prepped`
)

SELECT 
section,
-- site_short,
-- SUM(answer_score)
avg(answer_score) as score 
FROM calc_score
-- WHERE section = 'coaching_programming_section'
GROUP BY section
-- site_short
-- ORDER BY section, 
-- score,
-- site_short