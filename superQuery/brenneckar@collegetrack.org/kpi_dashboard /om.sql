WITH gather_survey_data AS (
  SELECT
    CT.site_short,
    S.contact_id,
    CASE
      WHEN my_site_is_run_effectively_examples_i_know_how_to_find_zoom_links_i_receive_site = "Strongly Agree" THEN 1
      WHEN my_site_is_run_effectively_examples_i_know_how_to_find_zoom_links_i_receive_site = 'Agree' THEN 1
      ELSE 0
    END AS agree_site_is_run_effectively
  FROM
    `data-studio-260217.surveys.fy21_hs_survey` S
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CT ON CT.Contact_Id = S.contact_id
 
),

survey_completion AS (
SELECT site_short,
SUM(student_count) AS student_count
FROM `data-studio-260217.surveys.fy21_hs_survey_completion`
GROUP BY site_short
)

SELECT
  GSD.site_short,
  COUNT(GSD.contact_Id) AS om_hs_completion_count,
  MAX(SC.student_count) AS om_hs_survey_denominator,
  SUM(GSD.agree_site_is_run_effectively) AS OM_agree_site_is_run_effectively
from
  gather_survey_data GSD
  LEFT JOIN survey_completion SC ON SC.site_short = GSD.site_short
GROUP BY
  GSD.site_short