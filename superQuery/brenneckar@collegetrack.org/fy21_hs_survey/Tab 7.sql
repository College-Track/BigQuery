WITH calc_score AS (
SELECT 
    section, 
    `data-studio-260217.surveys.determine_positive_answers`(answer) AS answer_score,

FROM `data-studio-260217.surveys.fy21_hs_survey_long_prepped`
)

SELECT *
FROM calc_score
WHERE answer_score = 1