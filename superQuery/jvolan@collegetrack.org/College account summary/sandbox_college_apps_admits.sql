WITH gather_college_apps AS
(
    SELECT
    ca.id AS college_app_id,
    ca.college_university_c,
    student_c,
    admission_status_c,
    CASE
        WHEN admission_status_c IN ("Accepted") THEN 1
        ELSE 0
    END AS admitted_y_n,
    a.name AS college_name,
    
    
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean` ca
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON a.id = ca.college_university_c
    WHERE application_status_c = "Applied"
),

gather_student_data AS
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
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AT_Grade_c = "12th Grade"
    AND term_c = "Spring"
),

join_data AS
(
    SELECT
    college_app_id,
    college_university_c,
    college_name,
    admitted_y_n,
    gsd.*
    
    FROM gather_college_apps
    LEFT JOIN gather_student_data gsd ON gsd.Contact_Id = student_c
    
)
    SELECT
    college_name,
    COUNT(college_app_id) AS total_applicants,
    SUM(admitted_y_n) AS total_admits,
    ROUND(SUM(admitted_y_n) / COUNT(college_app_id),2) AS ct_admit_rate,
    
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
    
    
    FROM join_data
        WHERE COLLEGE_NAME IN ("University of California, Davis")
    GROUP BY college_name
