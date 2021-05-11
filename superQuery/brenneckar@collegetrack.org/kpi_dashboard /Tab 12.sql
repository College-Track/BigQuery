WITH gather_test_data AS (
  SELECT
    contact_name_c,
    (
      belief_in_self_raw_score_c + engaged_living_raw_score_c + belief_in_others_raw_score_c + emotional_competence_raw_score_c
    ) AS covi_raw_score
  FROM
    `data-warehouse-289815.salesforce_clean.test_clean`
  WHERE
    co_vitality_indicator_c IS NOT NULL
    AND record_type_id = '0121M000001cmuDQAQ'
)
SELECT
  *
FROM
  gather_test_data
LIMIT
  100