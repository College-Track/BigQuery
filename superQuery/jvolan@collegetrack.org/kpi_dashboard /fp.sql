SELECT
    site_short,
    CASE
        WHEN fa_req_fafsa_c = 'Submitted' THEN 1
        ELSE 0
    END AS fp_12_fafsa_complete_num
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c = '11A'
    AND (grade_c = "12th Grade" OR (grade_c='Year 1' AND years_since_hs_grad_c = 0))