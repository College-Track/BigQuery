SELECT
    Contact_Id,
    AT_Id AS previous_academic_semester,
    CASE
        WHEN college_track_status_c = '17A' THEN NULL
        ELSE school_c
    END AS school,
    AT_school_type,
    cc_advisor_at_user_id_c AS cc_advisor_at,
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE major_c
    END AS major,
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE major_other_c
    END AS major_other,
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE second_major_c
    END AS second_major,
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE minor_c
    END AS minor,
    --adv rubric fields that carry over term to term
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE financial_aid_package_c
    END AS financial_aid_package,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE free_checking_account_c
    END AS free_checking_account,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     e_fund_c
    END AS     e_fund,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     repayment_plan_c
    END AS     repayment_plan,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE loan_exit_c
    END AS loan_exit,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     academic_networking_50_cred_c
    END AS     academic_networking_50_cred,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     academic_networking_over_50_credits_c
    END AS     academic_networking_over_50_credits,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     extracurricular_activity_c
    END AS     extracurricular_activity,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     finding_opportunities_75_c
    END AS     finding_opportunities_75,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     resume_cover_letter_c
    END AS     resume_cover_letter,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     career_counselor_25_credits_c
    END AS     career_counselor_25_credits,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     career_field_2550_credits_c
    END AS     career_field_2550_credits,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     resources_2550_credits_c
    END AS     resources_2550_credits,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     internship_5075_credits_c
    END AS     internship_5075_credits,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     post_graduate_plans_5075_creds_c
    END AS     post_graduate_plans_5075_creds,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     post_graduate_opportunities_75_cred_c
    END AS     post_graduate_opportunities_75_cred,
    
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE     alumni_network_75_credits_c
    END AS     alumni_network_75_credits,
    --for active, if summer and enrollment status is blank use prev. at enrollment status.
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        WHEN (college_track_status_c = '15A'
        AND term_c = 'Summer'
        AND enrollment_status_c IS NULL) THEN persistence_at_prev_enrollment_status_c
        ELSE enrollment_status_c
    END AS enrollment_status,
    CASE
        WHEN college_track_status_c <>'16A' THEN NULL
        ELSE cumulative_credits_awarded_most_recent_c
    END AS Cumulative_Credits_Awarded_All_Terms,

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND (college_track_status_c = '15A'
    OR (college_track_status_c IN ('16A','17A')
    AND indicator_years_since_hs_graduation_c <6))