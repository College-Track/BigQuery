 #table 1 
#Filtered College Applications - reporting group
    #contact data with college application data (no admission or acceptance data in this table)
/*CREATE OR REPLACE TABLE `data-studio-260217.college_applications.01_college_applications`
OPTIONS
    (
    description= "01 College Applications reporting group, student names. First table"
    )
AS */

SELECT DISTINCT
    
#college application data
    CA.id AS college_app_id_contact,
    CA.student_c,
    CASE  
        WHEN CA.application_status_c IS NULL THEN 'No College Application'
        ELSE CA.application_status_c
    END AS application_status,
 
#Contact 
    C.contact_id,
    c.full_name_c, 
    C.current_cc_advisor_2_c AS hs_ct_coach,
    C.high_school_graduating_class_c,
    C.npsp_primary_affiliation_c, 
    C.College_Track_Status_Name,
    C.college_eligibility_gpa_11th_grade,  #College Elig GPA (11th CGPA)
    CASE
        WHEN C.college_eligibility_gpa_11th_grade < 2.5 THEN '2.49 or below'
        WHEN (C.college_eligibility_gpa_11th_grade >=2.5 AND C.college_eligibility_gpa_11th_grade < 2.75) THEN '2.5 - 2.74'
        WHEN (C.college_eligibility_gpa_11th_grade >=2.75 AND C.college_eligibility_gpa_11th_grade < 3) THEN '2.75 - 2.99'
        WHEN (C.college_eligibility_gpa_11th_grade >=3 AND C.college_eligibility_gpa_11th_grade < 3.25) THEN '3 - 3.24'
        WHEN (C.college_eligibility_gpa_11th_grade >=3.25 AND C.college_eligibility_gpa_11th_grade < 3.5) THEN '3.25 - 3.49'
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
    CASE
        WHEN (site_short ='New Orleans' AND Region_Specific_Funding_Eligibility_c IN ('TOPS Honors Award Eligible','TOPS Performance Award Eligible','TOPS Opportunity Award Eligible','TOPS Tech Award Eligible','Not Eligible')) THEN Region_Specific_Funding_Eligibility_c
        WHEN (site_short IN ('East Palo Alto','Oakland','San Francisco','Sacramento','Boyle Heights','Watts') AND Region_Specific_Funding_Eligibility_c IN ('Cal Grant A Eligible','Cal Grant B Eligible','Cal Grant C Eligible','Not Eligible')) THEN Region_Specific_Funding_Eligibility_c
        WHEN site_short NOT IN ('New Orleans','East Palo Alto','Oakland','San Francisco','Sacramento','Boyle Heights','Watts') THEN 'Not Eligible'
    END AS Region_Specific_Funding_Eligibility,
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
    --accnt_2.name AS college_name_applied_wide #Wide filtter, college name on Application filter. Applications page. 
        
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS C    
LEFT JOIN `data-warehouse-289815.salesforce_clean.college_application_clean` AS CA 
        ON C.contact_id = CA.student_c 
LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt #pull in HS name from contact
        ON C.npsp_primary_affiliation_c = accnt.id 
LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt_2 #pull in college name in application 
        ON CA.College_University_c  = accnt_2.id    
    
--Need to make this dynamic to pull in students transitioning to PS in the Summer    
WHERE 
    (C.grade_c = '12th Grade' AND C.College_Track_Status_Name = 'Current CT HS Student') --Current 12th grade students
    OR
    (high_school_graduating_class_c = '2021'AND indicator_completed_ct_hs_program_c = TRUE) --historical 12th grade HS classes


--Apply this in WHERE clause before the Post-Secondary Record Type transition happens for rising freshman 
/*
AND student_audit_status_c = 'Current CT HS Student'
AND indicator_years_since_hs_grad_to_date_c = -.34
*/