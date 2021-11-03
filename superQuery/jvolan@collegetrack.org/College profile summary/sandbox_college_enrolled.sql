
WITH gather_all_enrolled_at_data AS
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
    situational_best_fit_c,
    SUM(credits_attempted_current_term_c) AS at_credit_attempt_num,
    SUM(CASE WHEN credits_attempted_current_term_c IS NOT NULL THEN 1 ELSE 0 END) AS at_credit_attempt_denom,
    SUM(credits_awarded_current_term_c) AS at_credit_awarded_num,
    SUM(CASE WHEN credits_awarded_current_term_c IS NOT NULL THEN 1 ELSE 0 END) AS at_credit_awarded_denom,
    AVG(credits_accumulated_c) AS avg_credits_accumulated,
    SUM(cumulative_credits_awarded_all_terms_c) AS c_credits_alltime_num,
    SUM(CASE WHEN cumulative_credits_awarded_all_terms_c IS NOT NULL THEN 1 ELSE 0 END) AS c_credits_alltime_denom,

    SUM(CASE WHEN on_track_c = "On-Track" THEN 1 ELSE 0 END) AS on_track_count,
    SUM(CASE WHEN on_track_c = "Near On-Track" THEN 1 ELSE 0 END) AS near_on_track_count,
    SUM(CASE WHEN on_track_c = "Off-Track" THEN 1 ELSE 0 END) AS off_track_count,
    SUM(CASE WHEN on_track_c IS NULL THEN 1 ELSE 0 END) AS missing_on_track_data_count,
    
    AVG(AT_Term_GPA) AS at_term_gpa,
    AVG(AT_Cumulative_GPA) AS avg_at_cgpa,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE student_audit_status_c IN ("Active: Post-Secondary", "CT Alumni")
    AND AT_School_Name IS NOT NULL
    GROUP BY AT_School_Name, AT_school_type, high_school_graduating_class_c, AT_Grade_c, GAS_Name, major_c, fit_type_at, situational_best_fit_c
)

    SELECT
    *
    FROM gather_all_enrolled_at_data