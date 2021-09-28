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