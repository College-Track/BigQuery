WITH

matriculation_and_current_enrollment AS (

SELECT 
    #contact data
    contact_id,
    full_name_c,
    high_school_class_c,
    indicator_college_matriculation_c,
    student_audit_status_c,
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
    enrolled_in_a_2_year_college_c AS matriculated_enrolled_in_a_2_year_college_2020_21,
    enrolled_in_a_4_year_college_c AS matriculated_enrolled_in_a_4_year_college_2020_21,
    enrolled_in_any_college_c AS matriculated_enrolled_in_any_college,
    fit_type_at_c AS matriculation_fit_type,
    at_grade_c AS matriculation_at_grade,
    AT_name AS matriculation_AT_name,
    at_id AS matriculation_at_id,
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
    term_c,
    fit_type_current_c,

    #academic term data
    school_academic_calendar_c,
    GAS_name, --global academic semester
    at_enrollment_status_c,
    AT_School_Name,
    AT_school_type,
    enrolled_in_a_2_year_college_c AS enrolled_in_a_2_year_college_2020_21,
    enrolled_in_a_4_year_college_c AS enrolled_in_a_4_year_college_2020_21,
    enrolled_in_any_college_c AS enrolled_in_any_college_2020_21,
    fit_type_at_c,
    AT_name,
    at_id,
    AY_name

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS contact_at

    WHERE
        indicator_completed_Ct_hs_program_c = TRUE
        AND high_school_class_c = '2020'
        AND AT_Record_Type_Name = 'College/University Semester' 
        AND AY_Name ='AY 2020-21' 
),

combine_groups AS (
SELECT
    #contact data
    base.contact_id,
    base.full_name_c,
    base.high_school_class_c,
    base.indicator_college_matriculation_c,
    base.student_audit_status_c,
    base.College_Track_Status_Name,
    base.site_short,
    base.region_short,
    
    #current enrollment data Fall 2021-22
    Current_school_name,
    Current_School_Type_c_degree,
    current_enrollment_status_c,
    school_predominant_degree_awarded_c AS current_school_type,
    current_enrollment_type,
    
    #Matriculation - Fall 2020-21 academic term data
    matriculation_college,
    matriculation_school_type,
    matriculated_enrolled_in_a_2_year_college_2020_21,
    matriculated_enrolled_in_a_4_year_college_2020_21,
    matriculated_enrolled_in_any_college,
    matriculation_fit_type,
    
    #2020-21 enrollment
    school_academic_calendar_c,
    GAS_name, --global academic semester
    at_enrollment_status_c,
    AT_School_Name,
    AT_school_type,
    enrolled_in_a_2_year_college_2020_21,
    enrolled_in_a_4_year_college_2020_21,
    enrolled_in_any_college_2020_21,
    fit_type_at_c,
    AT_name,
    at_id,
    AY_name

FROM matriculation_and_current_enrollment AS base
LEFT JOIN enrollment_data_2020_21 AS  enrollment ON base.contact_id=enrollment.contact_id

/*GROUP BY 
    full_name_c,
    contact_id,
    site_short,
    region_short,
    high_school_class_c,
    base.student_audit_status_c,
    enrolled_in_a_2_year_college_2020_21,
    enrolled_in_a_4_year_college_2020_21,
    enrolled_in_a_2_year_college_2021_22,
    enrolled_in_a_4_year_college_2021_22,
    college_track_status_name,
    fit_type_current_c,
    fit_type_at_c,
    at_enrollment_status_c
    */
    
),

enrollment_indicators AS (

        SELECT
        contact_id,
        high_school_class_c,
        college_track_status_name,
        student_audit_status_c,
        at_enrollment_status_c,
        site_short,
        region_short,
        fit_type_at_c,
        --fit_type_current_c,
    
    --Winter
    CASE 
        WHEN GAS_name = 'Winter 2020-21 (Quarter)' AND enrolled_in_a_2_year_college_2020_21 = TRUE
        THEN "enrolled_2_yr_2020_21"
        ELSE NULL
    END AS winter_enrollment_2_yr_2020_21,

    CASE 
        WHEN student_audit_status_c = "Active: Post-Secondary"
        AND enrolled_in_a_4_year_college_2020_21 = TRUE
        THEN "enrolled_4_yr_2020_21"
    END AS enrollment_4_yr_2020_21, 
    
    CASE 
        WHEN college_track_status_name = "Active: Post-Secondary"
        AND enrolled_in_a_2_year_college_2021_22 = TRUE
        THEN "enrolled_2_yr_2021_22"
    END AS enrollment_2_yr_2021_22,

    CASE 
        WHEN college_track_status_name = "Active: Post-Secondary"
        AND enrolled_in_a_4_year_college_2021_22 = TRUE
        THEN "enrolled_4_yr_2021_22"
    END AS enrollment_4_yr_2021_22

    FROM combine_groups
    )

    SELECT 
        *,
        CASE 
            WHEN at_enrollment_status_c = 'Approved Gap Year'
            AND enrollment_4_yr_2021_22 = 'enrolled_4_yr_2021_22'  
            THEN 1
            WHEN enrollment_4_yr_2020_21 = 'enrolled_4_yr_2020_21' AND enrollment_4_yr_2021_22 = 'enrolled_4_yr_2021_22'
            THEN 1
            WHEN enrollment_2_yr_2020_21 = 'enrolled_4_yr_2020_21' AND enrollment_4_yr_2021_22 = 'enrolled_4_yr_2021_22'
            THEN 1
            WHEN enrollment_2_yr_2020_21 = 'enrolled_2_yr_2020_21' AND enrollment_2_yr_2021_22 = 'enrolled_2_yr_2021_22'
            THEN 1
            ELSE 0
        END AS persistence_indicator

        
    FROM enrollment_indicators