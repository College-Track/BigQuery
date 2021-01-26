#college applications for current academic year, graduating HS class

CREATE OR REPLACE TABLE `data-studio-260217.college_applications.college_application_filtered_table`
OPTIONS
    (
    description= "Filtered College Application and Contact data. Acceptance and Enrollment data appended"
    )
AS

WITH 
filtered_data AS #contact data with college application data (no admission or acceptance data in this table)
(
SELECT
    
#college application data
    CA.id AS college_application_id,
    CA.student_c,
    CA.application_status_c,
    CASE  
        WHEN CA.application_status_c IS NULL THEN 'No College Application'
        ELSE CA.application_status_c
    END AS application_status,
    /*
    CASE
        WHEN admission_status_c IS NULL THEN "Admission Status Not Yet Updated"
        ELSE admission_status_c
    END AS admission_status_c,
    */

#Contact 
    C.full_name_c,
    C.contact_id, #use in "Application Status" chart as Metric
    C.current_cc_advisor_2_c AS hs_ct_coach,
    --((COUNT(DISTINCT CA.student_c))/(COUNT(DISTINCT C.contact_id))) AS percent_of_students, #percent of seniors with college application
    C.high_school_graduating_class_c,
    C.npsp_primary_affiliation_c, 
    C.College_Track_Status_Name,
    C.college_eligibility_gpa_11th_grade,  #College Elig GPA (11th CGPA)
    CASE
        WHEN C.college_eligibility_gpa_11th_grade < 2.5 THEN '2.49 or below'
        WHEN (C.college_eligibility_gpa_11th_grade >=2.5 AND C.college_eligibility_gpa_11th_grade < 3) THEN '2.5 - 2.99'
        WHEN (C.college_eligibility_gpa_11th_grade >=3 AND C.college_eligibility_gpa_11th_grade < 3.5) THEN '3 - 3.49'
        WHEN (C.college_eligibility_gpa_11th_grade >=3.5 AND C.college_eligibility_gpa_11th_grade < 4) THEN '3.5 - 3.99'
        WHEN (C.college_eligibility_gpa_11th_grade >=4 AND C.college_eligibility_gpa_11th_grade < 4.5) THEN '4 - 4.49'
        ELSE '4.5+ or above'
    END cgpa_11th_grade_bucket,
    C.grade_c, 
    C.Gender_c ,
    C.Ethnic_background_c ,
    C.indicator_low_income_c,
    C.first_generation_fy_20_c, 
    C.act_highest_composite_official_c,
    C.act_math_highest_official_c, 
    C.sat_highest_total_single_sitting_c,
    C.sat_math_highest_official_c,
    
    CASE
        WHEN (site_short = 'New Orleans' AND act_highest_composite_official_c >= 20 AND college_eligibility_gpa_11th_grade >=2.5) THEN 'TOPS eligible'
        WHEN site_short <> 'New Orleans' THEN 'Not Applicable'
        ELSE 'Not TOPS eligible'
    END AS TOPS_eligibility, 
    
    C.site_short,
    CASE
        WHEN C.site_short = "East Palo Alto" THEN 1
        WHEN C.site_short = "Oakland" THEN 2
        WHEN C.site_short = "San Francisco" THEN 3
        WHEN C.site_short = "Sacramento" THEN 4
        WHEN C.site_short = "New Orleans" THEN 5
        WHEN C.site_short = "Aurora" THEN 6
        WHEN C.site_short = "Denver" THEN 7
        WHEN C.site_short = "Boyle Heights" THEN 8
        WHEN C.site_short = "Watts" THEN 9
        ELSE 0
    END AS sort_helper_site,
    CASE
      WHEN C.site_short IS NOT NULL THEN "National"
    END AS National,
    C.region_short,
    C.readiness_english_official_c,
    C.readiness_composite_off_c,
    C.readiness_math_official_c,
    C.fa_req_expected_financial_contribution_c, 
    CASE 
        WHEN C.fa_req_expected_financial_contribution_c IS NULL THEN 'Missing EFC'
        ELSE 'Reported EFC' 
    END AS EFC_indicator,
    CASE 
        WHEN C.fa_req_expected_financial_contribution_c = 0 THEN 'Full Pell'
        WHEN C.fa_req_expected_financial_contribution_c >= 1 AND C.fa_req_expected_financial_contribution_c < 5711 THEN 'Partial Pell'
        WHEN C.fa_req_expected_financial_contribution_c >= 5711 THEN 'Pell Ineligible'
        WHEN C.fa_req_expected_financial_contribution_c IS NULL THEN 'Missing EFC'
    END AS Pell_indicator,
    C.fa_req_fafsa_c,
    CASE 
        WHEN C.fa_req_fafsa_c IS NULL THEN 'Missing Status' 
        ELSE C.fa_req_fafsa_c 
    END AS FAFSA_status,
    
    #account
    accnt.name AS high_school_name_filter,
    accnt_2.name AS college_name_applied_filter,
        
FROM `data-warehouse-289815.salesforce_clean.contact_template` AS C    
LEFT JOIN `data-warehouse-289815.salesforce_clean.college_application_clean` AS CA 
        ON C.contact_id = CA.student_c 
LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt #pull in HS name from contact
        ON C.npsp_primary_affiliation_c = accnt.id 
LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt_2 #pull in college name in application 
        ON CA.College_University_c  = accnt_2.id    
    
WHERE C.grade_c = '12th Grade'
AND C.College_Track_Status_Name = 'Current CT HS Student'
   
),

acceptance_data AS 
(
SELECT
    student_c AS student_c_accepted, #contact id
    accnt.name AS school_name_accepted,
    app.id AS college_accepted_app_id,
    CASE 
        WHEN admission_status_c = "Accepted" OR admission_status_c = "Accepted and Enrolled" OR admission_status_c = "Accepted and Deferred" 
        THEN 1
        ELSE 0
    END AS accepted,
    
    CASE 
        WHEN ((admission_status_c = "Accepted") AND (College_Fit_Type_Applied_c = "None") AND (app.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((admission_status_c = "Accepted") AND (College_Fit_Type_Applied_c = "None") AND (app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        WHEN admission_status_c = "Accepted" THEN  College_Fit_Type_Applied_c
        WHEN ((admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")) AND (fit_type_enrolled_c = "None") AND (app.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")) AND (fit_type_enrolled_c = "None") AND (app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        ELSE fit_type_enrolled_c
    END AS fit_type_accepted,
    
FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app
LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt
        ON app.College_University_c = accnt.id
        
WHERE app.admission_status_c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")
),

admission_data AS
(
SELECT 
    student_c AS contact_id_admissions,
    accnt.name AS school_name_enrolled,
    app.id AS college_enrolled_app_id,
    Type_of_School_c as school_type_enrolled,
    
    CASE
        WHEN admission_status_c IS NULL THEN "Admission Status Not Yet Updated"
        ELSE admission_status_c
    END AS admission_status_c,
    
    CASE
        WHEN ((fit_type_enrolled_c = "None") AND (app.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((fit_type_enrolled_c = "None") AND (app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        ELSE fit_type_enrolled_c
    END AS fit_type_enrolled_c,
    
    CASE
        WHEN admission_status_c = "Accepted" THEN 1
        WHEN admission_status_c = "Accepted and Enrolled" THEN 2
        WHEN admission_status_c = "Accepted and Deferred" THEN 3
        WHEN admission_status_c = "Wait-listed" THEN 4
        WHEN admission_status_c = "Conditional" THEN 5
        WHEN admission_status_c = "Withdrew Application" THEN 6
        WHEN admission_status_c = "Undecided" THEN 7
        WHEN admission_status_c = "Denied" THEN 8
        WHEN admission_status_c = "Admission Status Not Yet Updated" THEN 9
        ELSE 0
    END AS sort_helper_admission_status,
    
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app
    LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt
        ON app.College_University_c = accnt.id
     
    WHERE admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")
),

college_application_data AS #combine acceptance and admission data to college application data
(
SELECT
    app.name,
    app.Student_c AS contact_id_applied,
    
        (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app2.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting" AND app.student_c=app2.student_c
        AND application_status_c = "Applied"
        group by app2.student_c
        ) AS  contact_id_applied_4_year,
        
        (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app2.Predominant_Degree_Awarded_c = "Predominantly associate's-degree granting" AND app.student_c=app2.student_c
        AND application_status_c = "Applied"
        group by app2.student_c
        ) AS  contact_id_applied_2_year,
        
    app.Type_of_School_c as school_type_applied,
    accnt.name AS school_name_applied,
    app.College_University_c AS app_college_id, #college id
    app.Award_Letter_c,
    app.CSS_Profile_Required_c,
    app.CSS_Profile_c,
    CASE
        WHEN app.CSS_Profile_c IS NULL THEN 'Missing Status'
        ELSE app.CSS_Profile_c
    END AS CSS_profile_status,
    app.College_Fit_Type_Applied_c,
    app.College_University_Academic_Calendar_c,
    app.Control_of_Institution_c, #private or public school,
    app.Enrollment_Deposit_c,
    app.School_s_Financial_Aid_Form_Required_c, #yes/no
    app.School_Financial_Aid_Form_Status_c,
    CASE 
        WHEN app.School_Financial_Aid_Form_Status_c IS NULL THEN 'Missing Status'
        ELSE app.School_Financial_Aid_Form_Status_c
    END AS School_Financial_Aid_Form_Status,
    
    #CASE
    #    WHEN ((fit_type_enrolled_c = "None") AND (CA.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
    #    WHEN ((fit_type_enrolled_c = "None") AND (CA.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
    #    ELSE fit_type_enrolled_c
    #END AS fit_type_enrolled_c,
    
    app.id as college_app_id,
    app.Predominant_Degree_Awarded_c,
    app.Type_of_School_c,
    site_short AS site_applied,
    app.Situational_Fit_Type_c,
    app.Strategic_Type_c,
    app.Verification_Status_c,
    
    CASE
        WHEN ((College_Fit_Type_Applied_c = "None") AND (app.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((College_Fit_Type_Applied_c = "None") AND (app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        WHEN College_Fit_Type_Applied_c IS NULL THEN 'Has Not Yet Applied'
        ELSE College_Fit_Type_Applied_c
    END AS College_Fit_Type_Applied,
    
    #accepted_data 
    student_c_accepted,
    school_name_accepted,
    college_accepted_app_id,
    accepted,
    fit_type_accepted,
    
    #admissions_data
    contact_id_admissions,
    school_name_enrolled,
    college_enrolled_app_id,
    school_type_enrolled,
    admissions.admission_status_c,
    admissions.fit_type_enrolled_c,
    sort_helper_admission_status,
    
FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app
LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt
        ON app.College_University_c = accnt.id  
        
LEFT JOIN acceptance_data AS acceptance
    ON app.student_c = acceptance.student_c_accepted

LEFT JOIN admission_data AS admissions
    ON app.student_c = admissions.contact_id_admissions

)

SELECT 
    filtered_data.*,
    college_application_data.*,
        #EXCEPT (College_Fit_Type_Applied_c),
    
    CASE 
        WHEN application_status = 'No College Application' THEN 'No College Application'
        WHEN Strategic_Type_c IS NULL THEN 'No Type Selected'
        ELSE Strategic_Type_c
    END AS match_type, #match type
    
    CASE
        WHEN application_status = "Prospect" THEN 1
        WHEN application_status = "In Progress" THEN 2
        WHEN application_status = "Applied" THEN 3
        WHEN application_status = "Accepted" THEN 4
        WHEN application_status = "No College Application" THEN 5
        ELSE 6
    END AS sort_helper_app_status, 
    
    CASE
        WHEN College_Fit_Type_Applied = "Best Fit" THEN 1
        WHEN College_Fit_Type_Applied  = "Good Fit" THEN 2
        WHEN College_Fit_Type_Applied  = "Local Affordable" THEN 3
        WHEN College_Fit_Type_Applied  = "None - 4-year" THEN 4
        WHEN College_Fit_Type_Applied  = "None - 2-year or technical" THEN 5
        ELSE 6
    END AS sort_helper_app_by_fit_type,
    
    CASE
        WHEN fit_type_accepted = "Best Fit" THEN 1
        WHEN fit_type_accepted = "Good Fit" THEN 2
        WHEN fit_type_accepted = "Local Affordable" THEN 3
        WHEN fit_type_accepted = "None - 4-year" THEN 4
        WHEN fit_type_accepted = "None - 2-year or technical" THEN 5
        ELSE 6
    END AS sort_helper_acceptance_by_fit_type,
    
    /*
    CASE
        WHEN fit_type_enrolled_admission_table = "Best Fit" THEN 1
        WHEN fit_type_enrolled_admission_table = "Situational" THEN 2
        WHEN fit_type_enrolled_admission_table = "Good Fit" THEN 3
        WHEN fit_type_enrolled_admission_table = "Local Affordable" THEN 4
        WHEN fit_type_enrolled_admission_table = "None - 4-year" THEN 5
        WHEN fit_type_enrolled_admission_table = "None - 2-year or technical" THEN 6
        ELSE 7
    END AS sort_helper_enroll_by_fit_type, 
    */
    /*
    CASE  
        WHEN admission_status_c IN ("Accepted","Accepted and Enrolled", "Accepted and Deferred") THEN student_c_accepted
        ELSE NULL 
    END AS contact_id_accepted   
    */
FROM filtered_data AS filtered_data
LEFT JOIN college_application_data  AS college_application_data
    ON filtered_data.contact_id = college_application_data.contact_id_applied


