SELECT 
    #contact data
    contact_id,
    full_name_c,
    high_school_class_c,
    indicator_college_matriculation_c,
    College_Track_Status_Name,
    site_short,
    region_short,
    
    #current enrollment data Fall 2021-22
    Current_school_name,
    Current_School_Type_c_degree,
    current_enrollment_status_c,
    school_predominant_degree_awarded_c,
    CASE 
        WHEN (school_predominant_degree_awarded_c = "Predominantly bachelor's-degree granting" AND current_enrollment_status_c IN ('Full-time','Part-time'))
        THEN 'enrolled_in_a_4_year_college_2021_22'
        WHEN (school_predominant_degree_awarded_c = "Predominantly associate's-degree granting" AND current_enrollment_status_c IN ('Full-time','Part-time'))
        THEN 'enrolled_in_a_2_year_college_2021_22' 
        ELSE 'not enrolled'
    END AS current_enrollment_type,
        

    #Matriculation - Fall 2020-21 academic term data
    --at_enrollment_status_c,
    AT_School_Name AS matriculation_college,
    AT_school_type AS matriculation_school_type,
    AT_Enrollment_Status_c AS matriculation_enrollment_status,
    enrolled_in_a_2_year_college_c AS matriculated_enrolled_in_a_2_year_college_2020_21,
    enrolled_in_a_4_year_college_c AS matriculated_enrolled_in_a_4_year_college_2020_21,
    enrolled_in_any_college_c AS matriculated_enrolled_in_any_college,
    fit_type_at_c AS matriculation_fit_type,
    at_grade_c AS matriculation_at_grade,
    AY_name AS matriculation_AY_name

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS contact_at

    WHERE
    indicator_completed_Ct_hs_program_c = TRUE
    AND high_school_class_c = '2020'
    AND indicator_college_matriculation_c <> 'Did not matriculate'
    AND AT_Record_Type_Name = 'College/University Semester' 
    AND AY_Name = 'AY 2020-21' 
    AND term_c = 'Fall'
    ),

enrollment_data_2020_21 AS (

SELECT 
    #contact data
    contact_id,
    full_name_c,
    high_school_class_c,
    site_short,
    region_short,
    fit_type_current_c,

    #academic term data
    CASE 
        WHEN school_academic_calendar_c = 'Trimester system (three terms comprise academic year)' 
        THEN 'Quarter'
        WHEN school_academic_calendar_c = 'Semester system (two terms comprise academic year)'
        THEN 'Semester'
        ELSE school_academic_calendar_c
    END AS school_academic_calendar_c,
    GAS_name, --global academic semester
    at_enrollment_status_c,
    AT_School_Name,
    AT_school_type,
    enrolled_in_a_2_year_college_c AS enrolled_in_a_2_year_college_2020_21,
    enrolled_in_a_4_year_college_c AS enrolled_in_a_4_year_college_2020_21,
    enrolled_in_any_college_c AS enrolled_in_any_college_2020_21,
    fit_type_at_c,
    term_c

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS contact_at

    WHERE
        indicator_completed_Ct_hs_program_c = TRUE
        AND high_school_class_c = '2020'
        AND AT_Record_Type_Name = 'College/University Semester' 
        AND AY_Name ='AY 2020-21' 