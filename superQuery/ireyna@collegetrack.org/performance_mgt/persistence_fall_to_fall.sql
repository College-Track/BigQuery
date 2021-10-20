#Was student enrolled in any college Fall Year 1 and Fall Year 2
WITH

matriculation_and_current_enrollment AS (

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
        
    #Matriculation - Fall 2020-21 academic term data
    AT_School_Name AS matriculation_college,
    AT_school_type AS matriculation_school_type,
    fit_type_at_c AS matriculation_fit_type,
    
    #Is student currently enrolled in any school?
    CASE
        WHEN Current_School_Type_c_degree IN ("Predominantly bachelor's-degree granting","Predominantly associate's-degree granting")
        AND current_enrollment_status_c IN ('Full-time','Part-time')
        THEN TRUE
        ELSE FALSE
    END AS currently_enrolled_in_any_college

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS contact_at

    WHERE
    indicator_completed_Ct_hs_program_c = TRUE
    AND high_school_class_c = '2020'
    AND indicator_college_matriculation_c <> 'Did not matriculate'
    AND AT_Record_Type_Name = 'College/University Semester' 
    AND AY_Name = 'AY 2020-21' 
    AND term_c = 'Fall'
)

SELECT 
    *,
    #Persistence Indicator (WIDE)
    CASE
        WHEN currently_enrolled_in_any_college = TRUE
        THEN 1
        ELSE 0
    END AS persistence_indicator
    
FROM matriculation_and_current_enrollment