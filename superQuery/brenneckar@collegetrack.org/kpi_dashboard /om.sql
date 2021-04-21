WITH gather_data AS (
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
 
)
SELECT
  GD.site_short,
  COUNT(GD.contact_Id) AS om_hs_completion_count,
--   SUM(SC.student_count) AS om_hs_survey_denominator,
  SUM(agree_site_is_run_effectively) AS OM_agree_site_is_run_effectively
from
  gather_data GD
--   LEFT JOIN `data-studio-260217.surveys.fy21_hs_survey_completion` SC ON SC.site_short = GD.site_short
GROUP BY
  GD.site_short