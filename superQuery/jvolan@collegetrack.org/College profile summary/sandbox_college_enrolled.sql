
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
    CASE
        when current_as_c = TRUE THEN fit_type_current_c
        ELSE fit_type_at_c
    END AS fit_type_at,
    situational_best_fit_c,
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

gather_student_data AS
(
    SELECT
    Contact_Id,
    high_school_graduating_class_c,
    site_short,
    AT_Cumulative_GPA AS x_12_cgpa,
        CASE
            WHEN AT_Cumulative_GPA >=3.25 THEN 1
        END AS x_12_cgpa_325,
        CASE
            WHEN AT_Cumulative_GPA <3.25
            AND AT_Cumulative_GPA >=2.75 THEN 1
        END AS x_12_cgpa_275_325,
        CASE
            WHEN AT_Cumulative_GPA <2.75 THEN 1
        END AS x_12_cgpa_below_275,
        
    college_eligibility_gpa_11th_grade AS x_11_cgpa,
        CASE
            WHEN college_eligibility_gpa_11th_grade >=3.25 THEN "3.25+"
            WHEN 
            (college_eligibility_gpa_11th_grade < 3.25
            AND college_eligibility_gpa_11th_grade >= 2.75) THEN "2.75-3.25"
            WHEN college_eligibility_gpa_11th_grade < 2.75 THEN "Below 2.75"
            ELSE NULL
        END AS x_11_cgpa_bucket,
        CASE
            WHEN college_eligibility_gpa_11th_grade >=3.25 THEN 1
        END AS x_11_cgpa_325,
        CASE
            WHEN college_eligibility_gpa_11th_grade <3.25
            AND college_eligibility_gpa_11th_grade >=2.75 THEN 1
        END AS x_11_cgpa_275_325,
        CASE
            WHEN college_eligibility_gpa_11th_grade <2.75 THEN 1
        END AS x_11_cgpa_below_275,
    readiness_composite_off_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AT_Grade_c = "12th Grade"
    AND term_c = "Spring"
),

join_data AS
(
    SELECT
    gat.* except (Contact_Id),
    gsd.*
    
    FROM gather_all_enrolled_at_data gat
    LEFT JOIN gather_student_data gsd ON gat.Contact_Id = gsd.Contact_Id
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
    situational_best_fit_c,
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
    
    AVG(AT_Term_GPA) AS at_term_gpa,
    AVG(AT_Cumulative_GPA) AS avg_at_cgpa,
    
    site_short,
    x_11_cgpa_bucket,
    readiness_composite_off_c
    
    FROM join_data
    GROUP BY AT_School_Name, AT_school_type, high_school_graduating_class_c, AT_Grade_c, GAS_Name, major_c, fit_type_at, situational_best_fit_c, site_short, x_11_cgpa_bucket,readiness_composite_off_c
)
    SELECT
    * 
    FROM group_data
