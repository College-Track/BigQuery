WITH gather_hs_metrics  AS (
  SELECT
    C.region_abrev,
    C.site_short,
    COUNT(Contact_id) AS student_count,
    MAX(Account.college_track_high_school_capacity_v_2_c) AS hs_cohort_capacity,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce.account` Account ON Account.Id = C.site_c
    WHERE college_track_status_c = "11A"
  GROUP BY
  region_abrev,
    site_short
)
SELECT *
FROM gather_hs_metrics