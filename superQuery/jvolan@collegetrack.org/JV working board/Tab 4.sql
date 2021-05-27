    SELECT
    AT_Id,
    Contact_Id AS at_contact_id,
    site_short AS at_site,
--% of students completing FAFSA or equivalent
    CASE    
        WHEN filing_status_c = 'FS_G' THEN 1
        ELSE 0
    END AS indicator_fafsa_complete,
--% of students on-track to have less than $30K loan debt
    CASE
        WHEN 
        loans_c IN ('LN_G','LN_Y') THEN 1
        ELSE 0
    END AS indicator_loans_less_30k_loans,
--% of students attaining a well-balanced lifestyle    
    CASE
        WHEN Overall_Rubric_Color = 'Green' THEN 1
        ELSE 0
    END AS indicator_well_balanced,
--% of students understand that technical and interpersonal skills are needed to create opportunities now and in the future
    CASE
        WHEN advising_rubric_career_readiness_v_2_c = 'Green'
        AND 
        (academic_networking_50_cred_c = 'AN1_G'
        OR academic_networking_over_50_credits_c = 'AN2_G') THEN 1
        ELSE 0
    END AS indicator_tech_interpersonal_skills,
    CAST (CURRENT_DATE() AS DATE) AS determine_at_date,  
    current_as_c,
    previous_as_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE college_track_status_c = '15A'
    AND(
    (CURRENT_DATE() < '2021-07-01'
    AND current_as_c = TRUE)
    OR
    (CURRENT_DATE() > '2021-07-01'
    AND previous_as_c = TRUE))

   