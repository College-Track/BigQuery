SELECT
    site_short,
    SUM(
    CASE
        WHEN fa_req_expected_financial_contribution_c IS NOT NULL THEN 1
        ELSE 0
    END) AS fp_12_fafsa_complete_num
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c = '11A'
    AND (grade_c = "12th Grade" OR (grade_c='Year 1' AND indicator_years_since_hs_graduation_c = 0))
    GROUP BY site_short