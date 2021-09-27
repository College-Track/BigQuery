WITH gather_college_apps AS
(
    SELECT
    student_c,
    college_university_c,
    admission_status_c,
    CASE
        WHEN admission_status_c IN ("Accepted") THEN 1
        ELSE 0
    END AS admitted_y_n
    
    
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean`
    WHERE application_status_c = "Applied"
),

gather_student_data AS
(
    SELECT
    Contact_Id,
    AT_Cumulative_GPA AS x_12_cgpa,
    college_eligibility_gpa_11th_grade AS x_11_cgpa,
    act_highest_composite_official_c AS act_highest_comp,
    sat_highest_total_single_sitting_c AS sat_highest_total,
    readiness_composite_off_c,
    total_community_service_hours_completed_c,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AT_Grade_c = "12th Grade"
    AND term_c = "Spring"
),

join_data AS
(
    SELECT
    college_university_c,
    admitted_y_n,
    gsd.* except (Contact_Id)
    
    FROM gather_college_apps
    LEFT JOIN gather_student_data gsd ON gsd.Contact_Id = student_c
    
)
    SELECT
    *
    
    FROM join_data