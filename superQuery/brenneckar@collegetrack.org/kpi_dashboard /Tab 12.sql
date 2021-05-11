WITH gather_covi_data AS (
  SELECT
    contact_name_c,
    site_short,
    AY_Name,
    MIN(
      belief_in_self_raw_score_c + engaged_living_raw_score_c + belief_in_others_raw_score_c + emotional_competence_raw_score_c
    ) AS covi_raw_score
  FROM
    `data-warehouse-289815.salesforce_clean.test_clean` T
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.AT_Id = T.academic_semester_c
  WHERE
    T.record_type_id = '0121M000001cmuDQAQ'
    AND AY_Name IN ('AY 2019-20', 'AY 2020-21')
    AND CAT.College_track_status_c = '11A'
  GROUP BY
    site_short,
    contact_name_c,
    AY_Name
  ORDER BY
    site_short,
    contact_name_c,
    AY_Name
),
calc_covi_growth AS (
  SELECT
    site_short,
    contact_name_c,
    covi_raw_score - LAG(covi_raw_score) over (
      partition by contact_name_c
      order by
        AY_Name
    ) AS covi_growth
  FROM
    gather_covi_data
),
determine_covi_indicators AS (
  SELECT
    site_short,
    contact_name_c,
    CASE
      WHEN covi_growth > 0 THEN 1
      ELSE 0
    END AS covi_student_grew
  FROM
    calc_covi_growth
  WHERE
    covi_growth IS NOT NULL
)
 (SELECT
  site_short,
  SUM(covi_student_grew) AS SD_covi_student_grew,
  COUNT(contact_name_c) AS SD_covi_denominator
FROM
  determine_covi_indicators
GROUP BY
  site_short
  )