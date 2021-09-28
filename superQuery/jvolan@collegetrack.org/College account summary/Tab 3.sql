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