WITH

gather_at_data_2020_21 AS (

SELECT 
    #contact data
    contact_id,
    full_name_c,
    DV_Status_c AS dreamer_verified_status,
    high_school_class_c,
    student_audit_status_c,
    College_Track_Status_Name,
    site_short,
    region_short,
    school_predominant_degree_awarded_c,
    term_c,
    academic_year_term_4_year_degree_earned_c,
    academic_year_4_year_degree_earned_c,

    #academic term data
    at_enrollment_status_c,
    at_school_name AS College_Name_2020_21,
    
    #Show me the fit type from last year's Fall enrollment if student FT/PT
    CASE   
        WHEN at_enrollment_status_c IN ("Full-time","Part-time") THEN fit_type_at_c 
        ELSE at_enrollment_status_c 
    END AS fit_type_fall_2020_21,
    enrolled_in_a_2_year_college_c AS enrolled_in_a_2_year_college_2020_21,
    enrolled_in_a_4_year_college_c AS enrolled_in_a_4_year_college_2020_21,
    enrolled_in_any_college_c,
    at_grade_c,
    AT_name,
    at_id,
    AY_name,

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS contact_at

    WHERE
    indicator_completed_Ct_hs_program_c = TRUE
    AND AT_RecordType_ID = '01246000000RNnHAAW' #college/university semesters
    AND AY_Name = 'AY 2020-21' #compare Fall-to-Fall enrollment: Fall 2020-21 to Fall 2022-21
    AND term_c = 'Fall'
    AND student_audit_status_c = "Active: Post-Secondary"
    AND enrolled_in_any_college_c
    ),

gather_at_data_2021_22 AS (

SELECT 
    #contact data
    contact_id,
    full_name_c,
    high_school_class_c,
    site_short,
    region_short,
    school_predominant_degree_awarded_c,
    term_c,
    
    #academic term data
    at_enrollment_status_c AS enrollment_status_2021_22,
    at_school_name AS College_Name_2021_22,
    
    #Show me the fit type from current year's Fall enrollment if student FT/PT
     CASE   
        WHEN at_enrollment_status_c IN ("Full-time","Part-time") THEN fit_type_current_c --if student is enrolled FT/PT then render Fit Type
        ELSE at_enrollment_status_c 
     END AS fit_type_fall_2021_22,
    enrolled_in_a_2_year_college_c AS enrolled_in_a_2_year_college_2021_22,
    enrolled_in_a_4_year_college_c AS enrolled_in_a_4_year_college_2021_22,
    enrolled_in_any_college_c,
    at_grade_c,
    AT_name,
    at_id,
    AY_name,

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS contact_at

    WHERE
        indicator_completed_Ct_hs_program_c = TRUE
        AND AT_RecordType_ID = '01246000000RNnHAAW' #college/university semesters
        AND AY_Name ='AY 2021-22' #compare Fall-to-Fall enrollment: Fall 2020-21 to Fall 2022-21
        AND term_c = 'Fall'
    --AND contact_at.College_Track_Status_Name IN ('Active: Post-Secondary','CT Alumni')
),

combine_groups AS (
    SELECT
        fall_2020_21.full_name_c,
        fall_2020_21.contact_id,
        fall_2020_21.site_short,
        fall_2020_21.region_short,
        fall_2020_21.high_school_class_c,
        fall_2020_21.dreamer_verified_status,
        academic_year_term_4_year_degree_earned_c,
        academic_year_4_year_degree_earned_c,
        college_track_status_name,
        student_audit_status_c,
        College_Name_2020_21,
        College_Name_2021_22,
        fit_type_fall_2020_21,
        fit_type_fall_2021_22,
        enrollment_status_2021_22,
        enrolled_in_a_2_year_college_2020_21,
        enrolled_in_a_4_year_college_2020_21,
        enrolled_in_a_2_year_college_2021_22,
        enrolled_in_a_4_year_college_2021_22,

        CASE
            WHEN (fall_2020_21.term_c ="Fall" AND fall_2020_21.AY_Name = "AY 2020-21") THEN "Fall 2020-21 AY"
            ELSE "Fall 2022-21 AY"
        END AS fall_ay,

    FROM gather_at_data_2020_21 AS fall_2020_21
    LEFT JOIN gather_at_data_2021_22 AS  fall_2021_22 ON fall_2020_21.contact_id=fall_2021_22.contact_id

    GROUP BY 
        full_name_c,
        contact_id,
        site_short,
        region_short,
        high_school_class_c,
        dreamer_verified_status,
        fall_ay,
        fall_2020_21.student_audit_status_c,
        College_Name_2020_21,
        College_Name_2021_22,
        enrolled_in_a_2_year_college_2020_21,
        enrolled_in_a_4_year_college_2020_21,
        enrolled_in_a_2_year_college_2021_22,
        enrolled_in_a_4_year_college_2021_22,
        college_track_status_name,
        fit_type_fall_2020_21,
        fit_type_fall_2021_22,
        enrollment_status_2021_22,
        academic_year_term_4_year_degree_earned_c,
        academic_year_4_year_degree_earned_c
    ),

enrollment_indicators AS (
    SELECT
        full_name_c,
        contact_id,
        high_school_class_c,
        dreamer_verified_status,
        college_track_status_name,
        student_audit_status_c,
        academic_year_term_4_year_degree_earned_c,
        academic_year_4_year_degree_earned_c,
        site_short,
        region_short,
        College_Name_2020_21,
        College_Name_2021_22,
        fit_type_fall_2020_21,
        fit_type_fall_2021_22,
        enrollment_status_2021_22,

    CASE 
        WHEN student_audit_status_c = "Active: Post-Secondary"
        AND enrolled_in_a_2_year_college_2020_21 = TRUE --Fall 2020-21 AY
        THEN 1 --2 year
        ELSE 0
    END AS enrollment_2_yr_2020_21,

    CASE 
        WHEN student_audit_status_c = "Active: Post-Secondary"
        AND enrolled_in_a_4_year_college_2020_21 = TRUE --Fall 2020-21 AY
        THEN 1 --4 year
        ELSE 0
    END AS enrollment_4_yr_2020_21,
    
    CASE 
        WHEN college_track_status_name = "Active: Post-Secondary"
        AND enrolled_in_a_2_year_college_2021_22 = TRUE --Fall 2021-22 AY
        THEN 1 --2 year
        ELSE 0
    END AS enrollment_2_yr_2021_22,

    CASE 
        WHEN college_track_status_name = "Active: Post-Secondary"
        AND enrolled_in_a_4_year_college_2021_22 = TRUE --Fall 2021-22 AY
        THEN 1 --4 year
        ELSE 0
    END AS enrollment_4_yr_2021_22, 

    CASE
        WHEN college_track_status_name = 'CT Alumni'
        THEN 'Graduated'
        ELSE NULL
    END AS alumni_persistence
    FROM combine_groups
    )

, persistence_indicator AS (
    SELECT 
        *,
        CASE 
            WHEN alumni_persistence = 'Graduated'
            THEN 1
            WHEN enrollment_4_yr_2020_21 = 1 AND enrollment_4_yr_2021_22 = 1 -- enrolled in 4 year Fall to Fall
            THEN 1
            WHEN enrollment_2_yr_2020_21 = 1 AND enrollment_4_yr_2021_22 = 1 -- 2 year last year, 4 year this Fall 
            THEN 1
            WHEN enrollment_4_yr_2020_21 = 1 AND enrollment_2_yr_2021_22 = 1 -- 4 year last year, 2 year this Fall 
            THEN 1
            WHEN enrollment_2_yr_2020_21 = 1 AND enrollment_2_yr_2021_22 = 1 -- enrolled in 2 year Fall to Fall
            THEN 1
            ELSE 0
        END AS persistence_indicator_any_college,
        CASE 
            WHEN alumni_persistence = 'Graduated'
            THEN 1
            WHEN enrollment_4_yr_2020_21 = 1 AND enrollment_4_yr_2021_22 = 1 -- enrolled in 4 year Fall to Fall
            THEN 1
            WHEN enrollment_2_yr_2020_21 = 1 AND enrollment_4_yr_2021_22 = 1 -- 2 year last year, 4 year this Fall 
            THEN 0
            WHEN enrollment_2_yr_2020_21 = 1 AND enrollment_2_yr_2021_22 = 1 -- enrolled in 2 year Fall to Fall
            THEN 1
            ELSE 0
        END AS persistence_same_or_higher_level,

    FROM enrollment_indicators
)
    SELECT 
        *,
        CASE 
            WHEN fit_type_fall_2020_21 IN ("Best Fit","Situational","Good Fit","Local Affordable") 
            AND fit_type_fall_2021_22 IN ("Best Fit","Situational","Good Fit","Local Affordable") 
            THEN 1 -- "Persisting - Affordable College Enrollment"
            ELSE 0 -- "Did not persist to affordable option"
            END AS persisted_with_affordable_enrollment,
        CASE 
            WHEN fit_type_fall_2020_21 = "Best Fit"
            AND fit_type_fall_2021_22 = "Best Fit"
            THEN 1 
            ELSE 0
        END AS persisted_best_fit_enrollment
        
    FROM persistence_indicator 
