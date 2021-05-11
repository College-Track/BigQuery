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
  GROUP BY
    site_short,
    contact_name_c,
    AY_Name
  ORDER BY
    site_short,
    contact_name_c,
    AY_Name
)
-- calc_covi_growth AS (
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