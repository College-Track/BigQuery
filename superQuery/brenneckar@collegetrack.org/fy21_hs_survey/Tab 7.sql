WITH calc_score AS (
SELECT 
    site_short,
    section,
    sub_section,
    question,
    `data-studio-260217.surveys.determine_positive_answers`(answer) AS answer_score,

FROM `data-studio-260217.surveys.fy21_hs_survey_long_prepped`
)

SELECT 
sub_section,
-- question,
-- site_short,
-- SUM(answer_score)
avg(answer_score) as score 
FROM calc_score
WHERE sub_section = 'wellness_programming_services_subsection'
AND question != 'Did you engage with Wellness services at your site?'
GROUP BY sub_section
-- site_short
-- ORDER BY section, 
-- score,
-- site_short