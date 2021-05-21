WITH calc_score AS (
SELECT 
    site_short,
    section, 
    `data-studio-260217.surveys.determine_positive_answers`(answer) AS answer_score,

FROM `data-studio-260217.surveys.fy21_hs_survey_long_prepped`
)

SELECT section,site_short,
avg(answer_score) as score 
FROM calc_score
GROUP BY section, site_short
ORDER BY score, site_short