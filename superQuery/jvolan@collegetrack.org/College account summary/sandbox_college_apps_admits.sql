WITH gather_college_apps AS
(
    SELECT
    COUNT(ca.id) AS total_applications,
    a.name AS app_college_name,
    
    
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean` ca
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON a.id = ca.college_university_c
    WHERE application_status_c = "Applied"
    GROUP BY app_college_name
),

gather_college_admits AS
(
    SELECT
    ca.id,
    ca.college_university_c,
    student_c,
    admission_status_c,
    CASE
        WHEN admission_status_c IN ("Accepted", "Accepted and Enrolled","Accepted and Deferred") THEN 1
        ELSE 0
    END AS admitted_y_n,
    a.name AS college_name,
    
    
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean` ca
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON a.id = ca.college_university_c
    WHERE application_status_c = "Applied"
    AND admission_status_c IN ("Accepted", "Accepted and Enrolled","Accepted and Deferred") 
),

gather_admit_student_data AS
(
    SELECT
    Contact_Id,
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
            WHEN college_eligibility_gpa_11th_grade >=3.25 THEN 1
        END AS x_11_cgpa_325,
        CASE
            WHEN college_eligibility_gpa_11th_grade <3.25
            AND college_eligibility_gpa_11th_grade >=2.75 THEN 1
        END AS x_11_cgpa_275_325,
        CASE
            WHEN college_eligibility_gpa_11th_grade <2.75 THEN 1
        END AS x_11_cgpa_below_275,
    act_highest_composite_official_c AS act_highest_comp,
    sat_highest_total_single_sitting_c AS sat_highest_total,
    readiness_composite_off_c,
    total_community_service_hours_completed_c,
    two_year_college_applications_c+four_year_college_applications_c AS college_app_count,
    two_year_college_acceptances_c + four_year_college_acceptances_c AS college_acceptance_count,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AT_Grade_c = "12th Grade"
    AND term_c = "Spring"
),

join_admit_data AS
(
    SELECT
    gca.*,
    gasd.*
    
    FROM
    gather_college_admits gca
    LEFT JOIN gather_admit_student_data gasd ON gasd.Contact_Id = gca.student_c
),

admit_profile AS
(
    SELECT
    college_name,
    SUM(admitted_y_n) AS total_admits,
    
    avg(college_app_count) AS avg_college_apps_applied,
    avg(college_acceptance_count) AS avg_college_accept,
    
    avg(x_12_cgpa) AS avg_12_cgpa,
    SUM(x_12_cgpa_325)/COUNT(x_12_cgpa) AS x_12_325_percent,
    SUM(x_12_cgpa_275_325)/COUNT(x_12_cgpa) AS x_12_cgpa_275_325_percent,
    SUM(x_12_cgpa_below_275)/COUNT(x_12_cgpa) AS x_12_cgpa_below_275_percent,
    
    avg(x_11_cgpa) AS avg_11_cgpa,
    SUM(x_11_cgpa_325)/COUNT(x_11_cgpa) AS x_11_325_percent,
    SUM(x_11_cgpa_275_325)/COUNT(x_11_cgpa) AS x_11_cgpa_275_325_percent,
    SUM(x_11_cgpa_below_275)/COUNT(x_11_cgpa) AS x_11_cgpa_below_275_percent,
    
    avg(act_highest_comp) AS avg_act_highest_comp,
    avg(sat_highest_total) AS avg_sat_highest_total,
    
    FROM join_admit_data
    GROUP BY college_name
),

join_apps_summary AS
(
    SELECT
    total_applications,
    ap.*
    
    FROM gather_college_apps
    LEFT JOIN admit_profile ap ON ap.college_name = app_college_name
)

    SELECT
    *
    FROM join_apps_summary