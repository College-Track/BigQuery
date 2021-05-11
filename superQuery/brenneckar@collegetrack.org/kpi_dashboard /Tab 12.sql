WITH gather_test_data AS (
  SELECT
    contact_name_c,
    AY_Name,
    MIN(
      belief_in_self_raw_score_c + engaged_living_raw_score_c + belief_in_others_raw_score_c + emotional_competence_raw_score_c
    ) AS covi_raw_score,
    COUNT(id) AS num_test
  FROM
    `data-warehouse-289815.salesforce_clean.test_clean` T
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.AT_Id = T.academic_semester_c
  WHERE T.record_type_id = '0121M000001cmuDQAQ'
  GROUP BY contact_name_c, AY_Name
)
SELECT
  *
FROM
  gather_test_data
LIMIT
  100