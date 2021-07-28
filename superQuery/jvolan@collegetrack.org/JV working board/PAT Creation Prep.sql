    SELECT
    Contact_Id,
    AT_Id AS previous_academic_semester,
    school_c,
    cc_advisor_at_user_id_c AS cc_advisor_at,
    CASE
        WHEN college_track_status_c <> '15A' THEN NULL 
        ELSE major_c
    END AS major,
    major_other_c,
    second_major_c,
    minor_c,
    --adv rubric fields that carry over term to term
    financial_aid_package_c,
    free_checking_account_c,
    e_fund_c,
    repayment_plan_c,
    loan_exit_c,
    academic_networking_50_cred_c,
    academic_networking_over_50_credits_c,
    extracurricular_activity_c,
    finding_opportunities_75_c,
    resume_cover_letter_c,
    career_counselor_25_credits_c,
    career_field_2550_credits_c,
    resources_2550_credits_c,
    internship_5075_credits_c,
    post_graduate_plans_5075_creds_c,
    post_graduate_opportunities_75_cred_c,
    alumni_network_75_credits_c,
    CASE
        WHEN 
        (term_c = 'Summer'
        AND enrollment_status_c IS NULL) THEN persistence_at_prev_enrollment_status_c
        ELSE enrollment_status_c
    END AS enrollment_status,

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND college_track_status_c IN ('15A', '16A')