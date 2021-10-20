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
    school_predominant_degree_awarded_c,
    CASE 
        WHEN (school_predominant_degree_awarded_c = "Predominantly bachelor's-degree granting" AND current_enrollment_status_c IN ('Full-time','Part-time'))
        THEN 'enrolled_in_4_yr_current'
        WHEN (school_predominant_degree_awarded_c = "Predominantly associate's-degree granting" AND current_enrollment_status_c IN ('Full-time','Part-time'))
        THEN 'enrolled_in_2_yr_current' 
        ELSE 'not enrolled'
    END AS current_enrollment_type, --enrollment of current term (FY22 is Fall 2021-22)
        

    #Matriculation - Fall 2020-21 academic term data
    AT_School_Name AS matriculation_college,
    AT_school_type AS matriculation_school_type,
    fit_type_at_c AS matriculation_fit_type

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
        WHEN (REGEXP_CONTAINS(GAS_Name, r'Quarter')) THEN 'Quarter'
        WHEN (REGEXP_CONTAINS(GAS_Name, r'Semester')) THEN 'Semester'
    END AS calendar,
    GAS_name, --global academic semester
    at_enrollment_status_c,
    AT_School_Name,
    AT_school_type,
    enrolled_in_a_2_year_college_c AS AT_enrolled_in_a_2_year_college,
    enrolled_in_a_4_year_college_c AS AT_enrolled_in_a_4_year_college,
    enrolled_in_any_college_c AS AT_enrolled_in_any_college,
    fit_type_at_c,
    term_c

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS contact_at
 
    WHERE
        indicator_completed_Ct_hs_program_c = TRUE
        AND high_school_class_c = '2020'
        AND AT_Record_Type_Name = 'College/University Semester' 
        AND AY_Name ='AY 2020-21' 
        AND term_c <> 'Summer'
),

combine_groups AS (
SELECT
    #contact data
    base.contact_id,
    base.full_name_c,
    base.high_school_class_c,
    base.indicator_college_matriculation_c,
    base.College_Track_Status_Name,
    base.site_short,
    base.region_short,
    
    #current enrollment data Fall 2021-22
    Current_school_name,
    Current_School_Type_c_degree,
    current_enrollment_status_c,
    current_enrollment_type,
    
    #Matriculation - Fall 2020-21 academic term data
    matriculation_college,
    matriculation_school_type,
    matriculation_fit_type,
    
    #2020-21 enrollment
    calendar,
    GAS_name, --global academic semester
    at_enrollment_status_c,
    AT_School_Name,
    AT_school_type,
    AT_enrolled_in_a_2_year_college,
    AT_enrolled_in_a_4_year_college,
    AT_enrolled_in_any_college,
    fit_type_at_c,
    term_c

FROM matriculation_and_current_enrollment AS base
LEFT JOIN enrollment_data_2020_21 AS  enrollment ON base.contact_id=enrollment.contact_id

GROUP BY 
    full_name_c,
    contact_id,
    site_short,
    region_short,
    high_school_class_c,
    College_Track_Status_Name,
    indicator_college_matriculation_c,
    
    Current_school_name,
    Current_School_Type_c_degree,
    current_enrollment_status_c,
    current_enrollment_type,
    
    #Matriculation - Fall 2020-21 academic term data
    matriculation_college,
    matriculation_school_type,
    matriculation_fit_type,
    
    #2020-21 enrollment
    calendar,
    GAS_name, --global academic semester
    at_enrollment_status_c,
    AT_School_Name,
    AT_school_type,
    AT_enrolled_in_a_2_year_college,
    AT_enrolled_in_a_4_year_college,
    AT_enrolled_in_any_college,
    fit_type_at_c,
    term_c
),

enrollment_indicators AS (

        SELECT
        contact_id,
        high_school_class_c,
        college_track_status_name,
        site_short,
        region_short,
        
        #current enrollment data Fall 2021-22
        Current_school_name,
        Current_School_Type_c_degree,
        current_enrollment_status_c,
        current_enrollment_type,
        
        #Matriculation - Fall 2020-21 academic term data
        indicator_college_matriculation_c,
        
        #2020-21 enrollment
        at_enrollment_status_c,
        AT_enrolled_in_a_2_year_college,
        AT_enrolled_in_a_4_year_college,
        AT_enrolled_in_any_college,
        fit_type_at_c,
        term_c,
    
    --Quarter
    CASE --4-year
        WHEN calendar = 'Quarter' 
            AND indicator_college_matriculation_c = '4-year'
            AND term_c = 'Winter' 
            AND AT_enrolled_in_a_4_year_college = TRUE
            AND current_enrollment_type = 'enrolled_in_4_yr_current'
        THEN 1
        WHEN calendar = 'Quarter' 
            AND indicator_college_matriculation_c = '4-year'
            AND term_c = 'Spring' 
            AND AT_enrolled_in_a_4_year_college = TRUE
            AND current_enrollment_type = 'enrolled_in_4_yr_current'
        THEN 1
        ELSE 0
    END AS persist_4_yr_quarter,

    CASE --2-year
        WHEN calendar = 'Quarter' 
            AND indicator_college_matriculation_c = '2-year'
            AND term_c = 'Winter' 
            AND AT_enrolled_in_any_college = TRUE
            AND current_enrollment_type IN ('enrolled_in_2_yr_current','enrolled_in_4_yr_current')
        THEN 1
        WHEN calendar = 'Quarter' 
            AND indicator_college_matriculation_c = '2-year'
            AND term_c = 'Spring' 
            AND AT_enrolled_in_any_college = TRUE
            AND current_enrollment_type IN ('enrolled_in_2_yr_current','enrolled_in_4_yr_current')
        THEN 1
        ELSE 0
    END AS persist_2_yr_quarter,
    
    --Semester
    CASE --4-year
        WHEN calendar = 'Semester' 
        AND indicator_college_matriculation_c = '4-year'
        AND term_c = 'Spring' 
        AND AT_enrolled_in_a_4_year_college = TRUE
        AND current_enrollment_type ='enrolled_in_4_yr_current'
    THEN 1
    ELSE 0
    END AS persist_4_yr_semester,

    CASE --2-year
        WHEN calendar = 'Semester' 
        AND indicator_college_matriculation_c = '2-year'
        AND term_c = 'Spring' 
        AND AT_enrolled_in_any_college = TRUE
        AND current_enrollment_type IN ('enrolled_in_2_yr_current','enrolled_in_4_yr_current')
    THEN 1
    ELSE 0
    END AS persist_2_yr_semester
    
    FROM combine_groups
    
    GROUP BY 
        contact_id,
        high_school_class_c,
        college_track_status_name,
        site_short,
        region_short,
        
        #current enrollment data Fall 2021-22
        Current_school_name,
        Current_School_Type_c_degree,
        current_enrollment_status_c,
        current_enrollment_type,
        
        #Matriculation - Fall 2020-21 academic term data
        indicator_college_matriculation_c,
        
        #2020-21 enrollment
        calendar,
        calendar,
        at_enrollment_status_c,
        AT_enrolled_in_a_2_year_college,
        AT_enrolled_in_a_4_year_college,
        AT_enrolled_in_any_college,
        fit_type_at_c,
        term_c
    ),
    
    final_indicator AS(

    SELECT 
        contact_id,
        high_school_class_c,
        college_track_status_name,
        site_short,
        region_short,
        indicator_college_matriculation_c,
        
        #current enrollment data Fall 2021-22
        current_enrollment_status_c,
        current_enrollment_type,
    
        MAX(CASE 
            WHEN persist_4_yr_quarter = 1
            THEN 1
            WHEN persist_4_yr_semester = 1
            THEN 1
            WHEN persist_2_yr_quarter = 1
            THEN 1
            WHEN persist_2_yr_semester = 1
            THEN 1
            ELSE 0
        END) AS Indicator_Persisted_into_2nd_Year_CT__c
  
    FROM enrollment_indicators
    GROUP BY 
        contact_id,
        high_school_class_c,
        college_track_status_name,
        site_short,
        region_short,
        
        #current enrollment data Fall 2021-22
        current_enrollment_status_c,
        current_enrollment_type,
        indicator_college_matriculation_c
)
    
    SELECT
        base.contact_id,
        base.full_name_c,
        base.high_school_class_c,
        base.college_track_status_name,
        base.site_short,
        base.region_short,
        base.indicator_college_matriculation_c,
        
        #current enrollment data Fall 2021-22
        Current_school_name,
        Current_School_Type_c_degree,
        base.current_enrollment_status_c,
        base.current_enrollment_type,
        Indicator_Persisted_into_2nd_Year_CT__c	
        
    
    FROM matriculation_and_current_enrollment AS base
    LEFT JOIN final_indicator AS indicator ON base.contact_id = indicator.contact_id
    GROUP BY 
        contact_id,
        full_name_c,
        high_school_class_c,
        college_track_status_name,
        site_short,
        region_short,
        indicator_college_matriculation_c,
        
        #current enrollment data Fall 2021-22
        Current_school_name,
        Current_School_Type_c_degree,
        current_enrollment_status_c,
        current_enrollment_type,
        Indicator_Persisted_into_2nd_Year_CT__c	
        