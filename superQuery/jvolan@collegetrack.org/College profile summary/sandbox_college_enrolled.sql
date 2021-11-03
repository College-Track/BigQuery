
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
    AVG(credits_attempted_current_term_c) AS avg_at_credit_attempt,
    AVG(credits_awarded_current_term_c) AS avg_at_credit_awarded,
    AVG(credits_accumulated_c) AS avg_at_credits_accumulated,
    AVG(cumulative_credits_awarded_all_terms_c) AS avg_c_credits_alltime,

    on_track_c,
    
    AVG(AT_Term_GPA) AS at_term_gpa,
    AVG(AT_Cumulative_GPA) AS avg_at_cgpa,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE student_audit_status_c IN ("Active: Post-Secondary", "CT Alumni")
    AND AT_School_Name IS NOT NULL
    GROUP BY AT_School_Name, AT_school_type, high_school_graduating_class_c, AT_Grade_c, GAS_Name, major_c, fit_type_at, situational_best_fit_c, on_track_c
)

    SELECT
    *
    FROM gather_all_enrolled_at_data