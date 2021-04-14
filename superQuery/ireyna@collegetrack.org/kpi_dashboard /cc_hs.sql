SELECT
    contact_id,
    COUNT(DISTINCT applied_best_good_situational) AS cc_hs_best_good_situational,
    SUM(cc_hs_EFC_10th)
  FROM
    gather_data
  GROUP BY
    contact_id