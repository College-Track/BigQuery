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