WITH gather_college_apps AS
(
    SELECT
    COUNT(ca.id) AS total_applications,
    a.name AS app_college_name,
    a.id AS app_college_id,
    c.site_short,
    c.high_school_graduating_class_c,
    c.readiness_composite_off_c,
    CASE
        WHEN college_eligibility_gpa_11th_grade >=3.25 THEN "3.25+"
            WHEN 
            (college_eligibility_gpa_11th_grade < 3.25
            AND college_eligibility_gpa_11th_grade >= 2.75) THEN "2.75-3.25"
            WHEN college_eligibility_gpa_11th_grade < 2.75 THEN "Below 2.75"
            ELSE NULL
        END AS x_11_cgpa_bucket,
     
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean` ca
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON a.id = ca.college_university_c
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = ca.student_c
    WHERE application_status_c = "Applied"
    GROUP BY app_college_name, app_college_id, site_short, high_school_graduating_class_c, x_11_cgpa_bucket ,readiness_composite_off_c
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
    a.name AS admit_college_name,
    a.id AS admit_college_id,
    
    
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean` ca
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON a.id = ca.college_university_c
    WHERE application_status_c = "Applied"
    AND admission_status_c IN ("Accepted", "Accepted and Enrolled","Accepted and Deferred") 
),

gather_admit_student_data AS
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
    AT_Cumulative_GPA_bucket,
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
    admit_college_name,
    admit_college_id,
    site_short,
    high_school_graduating_class_c,
    readiness_composite_off_c,
    x_11_cgpa_bucket,
    SUM(admitted_y_n) AS total_admits,
    
    SUM(college_app_count) AS avg_admit_apps_applied_num,
    
    SUM(college_acceptance_count) AS avg_admit_apps_accept_num,
    
    ROUND(avg(x_12_cgpa),2) AS avg_12_cgpa,
    SUM(x_12_cgpa_325) AS x_12_cgpa_325_percent_num,
    SUM(x_12_cgpa_275_325) AS x_12_cgpa_275_325_percent_num,
    SUM(x_12_cgpa_below_275) AS x_12_cgpa_below_275_percent_num,
    COUNT(x_12_cgpa) AS x_12_cgpa_percent_denom,
    
    ROUND(avg(x_11_cgpa),2) AS avg_11_cgpa,
    SUM(x_11_cgpa_325) AS x_11_cgpa_325_percent_num,
    SUM(x_11_cgpa_275_325) AS x_11_cgpa_275_325_percent_num,
    SUM(x_11_cgpa_below_275) AS x_11_cgpa_below_275_percent_num,
    COUNT(x_11_cgpa) AS x_11_cgpa_percent_denom,
    
    avg(act_highest_comp) AS avg_act_highest_comp,
    avg(sat_highest_total) AS avg_sat_highest_total,
    
    FROM join_admit_data
    GROUP BY admit_college_name, admit_college_id, site_short, high_school_graduating_class_c, x_11_cgpa_bucket ,readiness_composite_off_c
)
   
    SELECT
    total_applications,
    app_college_name,
    app_college_id AS account_id,
    ap.* except (admit_college_name),
    
    FROM gather_college_apps gca
    LEFT JOIN admit_profile ap ON admit_college_id = app_college_id
    AND gca.site_short = ap.site_short
    AND gca.high_school_graduating_class_c = ap.high_school_graduating_class_c
    AND gca.x_11_cgpa_bucket = ap.x_11_cgpa_bucket
    AND gca.readiness_composite_off_c = ap.readiness_composite_off_c
