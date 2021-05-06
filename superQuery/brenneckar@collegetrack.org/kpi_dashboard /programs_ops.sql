WITH gather_data AS (
  SELECT
    Contact_Id,
    site_short,
    CASE
      WHEN grade_c = '9th Grade'
      AND (indicator_first_generation_c = true) THEN 1
      ELSE 0
    END AS incoming_cohort_first_gen,
        CASE
      WHEN grade_c = '9th Grade'
      AND (indicator_low_income_c = 'Yes' ) THEN 1
      ELSE 0
    END AS incoming_cohort_low_income,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
)
SELECT
  site_short,
  SUM(incoming_cohort_first_gen) AS pro_ops_incoming_cohort_first_gen,
  SUM(incoming_cohort_low_income) AS pro_ops_incoming_cohort_low_income
FROM
  gather_data
GROUP BY
  site_short