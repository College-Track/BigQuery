
WITH gather_all_enrolled_at_data AS
(    
    SELECT
    Contact_Id,
    AT_Id,
    AT_Grade_c,
    GAS_Name,
    AT_School_Name,
    AT_school_type,
    major_c,
    CASE WHEN current_as_c = TRUE THEN fit_type_current_c ELSE fit_type_at_c END AS fit_type_at,
    CASE WHEN situational_best_fit_c = "High Grad Rate Program" THEN 1 ELSE 0 END AS sfit_high_grad_program,
    CASE WHEN situational_best_fit_c = "High Grad Rate Major" THEN 1 ELSE 0 END AS sfit_high_grad_major,
    CASE WHEN situational_best_fit_c = "High Grad Rate and Affordable" THEN 1 ELSE 0 END AS sfit_high_grad_afford,
    CASE WHEN situational_best_fit_c = "DOOR" THEN 1 ELSE 0 END AS sfit_door,
    CASE WHEN situational_best_fit_c = "Other" THEN 1 ELSE 0 END AS sfit_other,
    credits_attempted_current_term_c,
    credits_awarded_current_term_c,
    credits_accumulated_c,
    cumulative_credits_awarded_all_terms_c,
    CASE WHEN on_track_c = "On-Track" THEN 1 ELSE 0 END AS on_track_count,
    CASE WHEN on_track_c = "Near On-Track" THEN 1 ELSE 0 END AS near_on_track_count,
    CASE WHEN on_track_c = "Off-Track" THEN 1 ELSE 0 END AS off_track_count,
    CASE WHEN on_track_c IS NULL THEN 1 ELSE 0 END AS missing_on_track_data_count,
    AT_Term_GPA,
    AT_Cumulative_GPA,
    current_as_c,
    fit_type_current_c,
    fit_type_at_c
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE student_audit_status_c IN ("Active: Post-Secondary", "CT Alumni")
    AND AT_School_Name IS NOT NULL
),

join_data AS
(
    SELECT
    gat.* except (Contact_Id),
    gsd.*
    
    FROM gather_all_enrolled_at_data gat
    LEFT JOIN `data-studio-260217.college_account_summary.gather_hs_contact_data_view` gsd ON gat.Contact_Id = gsd.Contact_Id
),
   
group_data AS
(    
    SELECT
    COUNT(DISTINCT(Contact_Id)) AS at_unique_student_count,
    COUNT(AT_Id) AS at_count,
    high_school_graduating_class_c,
    AT_Grade_c,
    GAS_Name,
    AT_School_Name,
    AT_school_type,
    major_c,
    CASE
        when current_as_c = TRUE THEN fit_type_current_c
        ELSE fit_type_at_c
    END AS fit_type_at,
    SUM(sfit_high_grad_program) AS sfit_high_grad_program_count,
    SUM(sfit_high_grad_major) AS sfit_high_grad_major_count,
    SUM(sfit_high_grad_afford) AS sfit_high_grad_afford_count,
    SUM(sfit_door) AS sfit_door_count,
    SUM(sfit_other) AS sfit_other_count,
    SUM(credits_attempted_current_term_c) AS at_credit_attempt_num,
    SUM(CASE WHEN credits_attempted_current_term_c IS NOT NULL THEN 1 ELSE 0 END) AS at_credit_attempt_denom,
    SUM(credits_awarded_current_term_c) AS at_credit_awarded_num,
    SUM(CASE WHEN credits_awarded_current_term_c IS NOT NULL THEN 1 ELSE 0 END) AS at_credit_awarded_denom,
    AVG(credits_accumulated_c) AS avg_credits_accumulated,
    SUM(cumulative_credits_awarded_all_terms_c) AS c_credits_alltime_num,
    SUM(CASE WHEN cumulative_credits_awarded_all_terms_c IS NOT NULL THEN 1 ELSE 0 END) AS c_credits_alltime_denom,

    SUM(on_track_count) AS on_track_count,
    SUM(near_on_track_count) AS near_on_track_count,
    SUM(off_track_count) AS off_track_count,
    SUM(missing_on_track_data_count) AS missing_on_track_data_count,
    
    SUM(AT_Term_GPA) AS at_term_gpa_num,
    SUM(CASE WHEN AT_Term_GPA IS NOT NULL THEN 1 ELSE 0 END) AS at_term_gpa_denom,
    SUM(AT_Cumulative_GPA) AS avg_at_cgpa_num,
    SUM(CASE WHEN AT_Cumulative_GPA IS NOT NULL THEN 1 ELSE 0 END) AS at_cgpa_denom,

    
    site_short,
    x_11_cgpa_bucket,
    readiness_composite_off_c
    
    FROM join_data
    GROUP BY AT_School_Name, AT_school_type, high_school_graduating_class_c, AT_Grade_c, GAS_Name, major_c, fit_type_at, site_short, x_11_cgpa_bucket,readiness_composite_off_c
)
    SELECT
    * 
    FROM group_data
