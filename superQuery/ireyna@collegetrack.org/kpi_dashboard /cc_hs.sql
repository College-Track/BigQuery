SELECT
    Contact_Id,
    site_short,
    grade_c,
    FA_Req_Expected_Financial_Contribution_c,
    fa_req_efc_source_c,
    CASE
        WHEN (FA_Req_Expected_Financial_Contribution_c IS NOT NULL) AND (fa_req_efc_source_c = 'FAFSA4caster') THEN 1
        ELSE 0
    END AS hs_EFC_10th
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE  college_track_status_c = '11A'
    AND grade_c = '10th Grade'