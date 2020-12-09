#college applications for current academic year, graduating HS class

WITH filtered_college_applications AS #compile college application, contact data, academic term data for GPA
(
SELECT

#Account object mapping
    ACCNT.Name, #college_name
    
#college application data    
    CA.Student__c AS contact_id,
    CA.College_University__c AS college_id,
    CA.College_Track_Site__c,
    CA.admission_status__c,
    CA.Application_status__c,
    CA.Average_Financial_Aid_Package__c,
    CA.Avg_Debt_of_Graduates__c,
    CA.Award_Letter__c,
    CA.CSS_Profile_Required__c,
    CA.CSS_Profile__c AS CSS_profile_status,
    CA.School_Financial_Aid_Form_Status__c,
    CA.College_Fit_Type_Applied__c,
    CA.College_University_Academic_Calendar__c,
    CA.Control_of_Institution__c, #private or public school,
    CA.Enrollment_Deposit__c,
    CA.Fit_Type_Current__c,
    CA.Fit_Type_Enrolled__c,
    CA.Housing_Application__c,
    CA.Id AS college_app_id,
    CA.Predominant_Degree_Awarded__c,
    CA.Type_of_School__c,
    CA.Situational_Fit_Type__c,
    CA.Strategic_Type__c AS match_type, #match type
    CA.Verification_Status__c,

#Contact, demo, academic data   
    C.full_name_c,
    C.College_Track_Status_Name,
    C.grade_c, 
    C.Gender_c ,
    C.Ethnic_background_c ,
    C.indicator_low_income_c,
    C.first_generation_fy_20_c, 
    C.site_short,
    C.region_short,
    C.readiness_english_official_c,
    C.readiness_composite_off_c,
    C.readiness_math_official_c,
    C.fa_req_expected_financial_contribution_c, 

 #Academic Term data 
    A_T.gpa_semester_cumulative_c AS CGPA_11th,
    A_T.AT_Record_Type_Name,
    A_T.Name, #academic term name
    A_T.grade_c,
    A_T.AT_Grade_c
    
FROM `data-warehouse-289815.salesforce_raw.College_Application__c` AS CA 
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` AS C
        ON CA.Student__c = C.Contact_Id
LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt #to pull in college name
        ON CA.College_University__c = accnt.id
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` AS A_T
        ON CA.Student__c = A_T. Contact_Id 
        

WHERE C.grade_c = '12th Grade'
    AND C.College_Track_Status_Name = 'Current CT HS Student'
    --AND A_T.Grade_c = '11th Grade'
    --AND AT_Record_Type_Name = 'High School Semester'
    --AND A_T.indicator_years_since_hs_graduation_c  = -1.34
    AND A_T.indicator_years_since_hs_grad_to_date_c = -1.34
)

SELECT *
FROM filtered_college_applications
LIMIT 50