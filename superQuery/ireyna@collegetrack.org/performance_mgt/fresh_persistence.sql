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
        WHEN Academic_Calendar_Value_c = 'Trimester system (three terms comprise academic year)' 
        THEN 'Quarter'
        WHEN Academic_Calendar_Value_c = 'Semester system (two terms comprise academic year)'
        THEN 'Semester'
        WHEN Academic_Calendar_Value_c = '4-1-4 system (two semesters & one-month January interterm)'
        THEN 'Semester'
        ELSE Academic_Calendar_Value_c
    END AS Academic_Calendar_Value_c,
    GAS_name, --global academic semester
    at_enrollment_status_c,
    AT_School_Name,
    AT_school_type,
    enrolled_in_a_2_year_college_c,
    enrolled_in_a_4_year_college_c,
    enrolled_in_any_college_c,
    fit_type_at_c,
    term_c

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS contact_at
    LEFT JOIN `data-warehouse-289815.salesforce.account` AS account
        ON contact_at.school_c = account.id
        
    WHERE
        indicator_completed_Ct_hs_program_c = TRUE
        AND high_school_class_c = '2020'
        AND AT_Record_Type_Name = 'College/University Semester' 
        AND AY_Name ='AY 2020-21' 
        AND term_c <> 'Summer'