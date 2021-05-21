WITH calc_score AS (
  SELECT
    S.site_short,
    section,
    sub_section,
    question,
    `data-studio-260217.surveys.determine_positive_answers`(answer) AS answer_score,
  FROM
    `data-studio-260217.surveys.fy21_hs_survey_long_prepped` S
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON C.contact_Id = S.contact_id
    WHERE C.Ethnic_background_c = "African-American" AND C.Gender_c = 'Male'
)
SELECT
  section,
  -- question,
  site_short,
  -- SUM(answer_score)
  avg(answer_score) as score
FROM
  calc_score -- WHERE sub_section = 'wellness_programming_services_subsection'
WHERE
  question != 'Did you engage with Wellness services at your site?'
  AND sub_section != 'virtual_programming_return_to_ct_subsection'
  AND sub_section != 'bank_book_subsection'
--   OR sub_section = 'virtual_programming_self_direction_subsection'
--   OR sub_section = 'virtual_programming_collaboration_subsection'
GROUP BY
  section,
  site_short
  ORDER BY section,
  score,
  site_short