#table 4 final join
#Join reporting group to final transformations
CREATE OR REPLACE TABLE `data-studio-260217.college_applications.04_college_applications`
OPTIONS
    (
    description= "04 Some transformations, Final Join of 01, 02, 03. Table 4."
    )
AS
SELECT DISTINCT 
    reporting_group.*,
    college_application_data.* EXCEPT (
                contact_id_accepted,
                college_name_on_app_for_case_statement, 
                application_status_app_table, 
                fit_type_accepted,
                fit_type_enrolled_c,
                College_Fit_Type_Applied_sort,
                fit_type_accepted_tight,
                college_app_id_contact,
                student_c,
                application_status,
                contact_id,
                full_name_c,
                hs_ct_coach,
                high_school_graduating_class_c,
                npsp_primary_affiliation_c, 
                College_Track_Status_Name,
                college_eligibility_gpa_11th_grade, 
                cgpa_11th_grade_bucket,
                grade_c, 
                Gender_c ,
                Ethnic_background_c ,
                indicator_low_income_c,
                first_generation_fy_20_c, 
                act_highest_composite_official_c,
                act_math_highest_official_c, 
                sat_highest_total_single_sitting_c,
                sat_math_highest_official_c,
                TOPS_eligibility,
                site_short,
                sort_helper_site,
                region_short,
                national,
                Region_Specific_Funding_Eligibility,
                readiness_english_official_c,
                readiness_composite_off_c,
                readiness_math_official_c,
                fa_req_expected_financial_contribution_c,
                EFC_indicator,
                fa_req_fafsa_c,
                FAFSA_status,
                Pell_indicator,
                high_school_name_filter
                ),
    table_3.* EXCEPT (
                college_app_id_contact,
                student_c,
                application_status,
                contact_id,
                full_name_c,
                hs_ct_coach,
                high_school_graduating_class_c,
                npsp_primary_affiliation_c, 
                College_Track_Status_Name,
                college_eligibility_gpa_11th_grade, 
                cgpa_11th_grade_bucket,
                grade_c, 
                Gender_c ,
                Ethnic_background_c ,
                indicator_low_income_c,
                first_generation_fy_20_c, 
                act_highest_composite_official_c,
                act_math_highest_official_c, 
                sat_highest_total_single_sitting_c,
                sat_math_highest_official_c,
                TOPS_eligibility,
                site_short,
                sort_helper_site,
                region_short,
                national,
                Region_Specific_Funding_Eligibility,
                readiness_english_official_c,
                readiness_composite_off_c,
                readiness_math_official_c,
                fa_req_expected_financial_contribution_c,
                EFC_indicator,
                fa_req_fafsa_c,
                FAFSA_status,
                Pell_indicator,
                high_school_name_filter
            ),
    CASE 
        WHEN (contact_id_status_not_applied IS NOT NULL OR college_application_data.application_status IS NULL) THEN 'Has Not Applied'
        WHEN college_application_data.admission_status_c IS NULL THEN "Admission Status Not Yet Updated"
        WHEN college_application_data.admission_status_c NOT IN ('Accepted','Accepted and Enrolled', 'Accepted and Deferred') THEN 'Denied, Waitlisted, Conditional'
        ELSE college_application_data.fit_type_accepted_tight
    END AS fit_type_accepted,
    
    CASE
        WHEN (contact_id_status_not_applied IS NOT NULL OR college_application_data.application_status IS NULL) THEN 'Has Not Applied'
        WHEN college_application_data.admission_status_c IS NULL THEN "Admission Status Not Yet Updated"
        ELSE college_application_data.admission_status_c
    END AS admission_status, 
    
    CASE
        WHEN (contact_id_status_not_applied IS NOT NULL OR college_application_data.application_status IS NULL) THEN 'Has Not Applied'
        WHEN ((college_application_data.fit_type_enrolled_c = "None") AND (college_application_data.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((college_application_data.fit_type_enrolled_c = "None") AND (college_application_data.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        WHEN college_application_data.admission_status_c IS NULL THEN "Admission Status Not Yet Updated"
        WHEN college_application_data.admission_status_c <> 'Accepted and Enrolled'AND college_application_data.admission_status_c <> 'Accepted and Deferred' THEN 'Not Yet Enrolled'
        ELSE college_application_data.fit_type_enrolled_c
    END AS fit_type_enrolled,
    
    CASE 
        WHEN (contact_id_status_not_applied IS NOT NULL OR college_application_data.application_status IS NULL) THEN 'Has Not Applied'
        WHEN college_application_data.admission_status_c IN ('Accepted and Enrolled', 'Accepted and Deferred') THEN college_application_data.school_type
        WHEN college_application_data.admission_status_c IS NULL THEN "Admission Status Not Yet Updated"
        WHEN college_application_data.admission_status_c NOT IN ('Accepted and Enrolled', 'Accepted and Deferred') THEN 'Not Yet Enrolled'
    END AS school_type_enrolled,  

FROM `data-studio-260217.college_applications.01_college_applications`  AS reporting_group
LEFT JOIN `data-studio-260217.college_applications.02_college_applications` AS college_application_data
    ON reporting_group.contact_id = college_application_data.contact_id_app_table 
LEFT JOIN `data-studio-260217.college_applications.03_college_applications` AS table_3
    ON reporting_group.contact_id = table_3.contact_id