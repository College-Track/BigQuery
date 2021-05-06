 SELECT
    AT_Id,
    Contact_Id AS at_contact_id,
    site_short AS at_site,
    CASE    
        WHEN filing_status_c = 'FS_G' THEN 1
        ELSE 0
    END AS indicator_fafsa_complete,
    CASE
        WHEN 
        loans_c IN ('LN_G','LN_Y') THEN 1
        ELSE 0
    END AS indicator_loans_less_30k_loans,
    CASE
        WHEN Overall_Rubric_Color = 'Green' THEN 1
        ELSE 0
    END AS indicator_well_balanced,
    CASE
        WHEN advising_rubric_career_readiness_v_2_c = 'Green'
        AND 
        (academic_networking_50_cred_c = 'Green'
        OR academic_networking_over_50_credits_c = 'Green') THEN 1
        ELSE 0
    END AS indicator_tech_interpersonal_skills
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = true
    AND college_track_status_c = '15A'