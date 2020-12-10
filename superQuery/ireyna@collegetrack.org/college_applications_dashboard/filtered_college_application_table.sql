#college applications for current academic year, graduating HS class

CREATE OR REPLACE TABLE `data-studio-260217.college_applications.college_application_filtered_table`
OPTIONS
    (
    description= "Filtered College Application, College Aspiration data. Pulls GPA data from Academic Term"
    )
AS

WITH filtered_data AS #compile college application, contact data, academic term data for GPA
(
SELECT
    
#college application data    
    CA.Student__c AS contact_id,
    CA.College_University__c AS app_college_id,
    CA.College_Track_Site__c,
    CA.admission_status__c,
    CA.Application_status__c,
    CA.Average_Financial_Aid_Package__c,
    CA.Avg_Debt_of_Graduates__c,
    CA.Award_Letter__c,
    CA.CSS_Profile_Required__c,
    CA.CSS_Profile__c AS CSS_profile_status,
    CA.College_Fit_Type_Applied__c,
    CA.College_University_Academic_Calendar__c,
    CA.Control_of_Institution__c, #private or public school,
    CA.Enrollment_Deposit__c,
    CA.School_s_Financial_Aid_Form_Required__c, #yes/no
    CA.School_Financial_Aid_Form_Status__c,
    CA.Fit_Type_Current__c,
    CA.Fit_Type_Enrolled__c,
    CA.Housing_Application__c,
    CA.Id AS college_app_id,
    CA.Predominant_Degree_Awarded__c,
    CA.Type_of_School__c,
    CA.Situational_Fit_Type__c,
    CA.Strategic_Type__c AS match_type, #match type
    CA.Verification_Status__c,

#Contact 
    C.full_name_c,
    C.high_school_graduating_class_c,
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
    
#College Aspiration data,
    CAP.Id AS aspiration_id,
    CAP.Aspiration_Category__c,
    CAP. College_University__c AS aspiration_college_id,
    
#Academic Term data 
    A_T.gpa_semester_cumulative_c AS CGPA_11th,
    A_T.Name AS Name_AT, #academic term name
    A_T.AT_Grade_c, #grade on AT
    A_T.AT_Record_Type_Name,
    
#Account object mapping
    ACCNT_APP.Name AS app_college_name, 
    ACCNT_ASP.Name AS aspiration_college_name
    
    
FROM `data-warehouse-289815.salesforce_raw.College_Application__c` AS CA 
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` AS C
        ON CA.Student__c = C.Contact_Id
LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt_app #pull in college name in application 
        ON CA.College_University__c = accnt_app.id
LEFT JOIN `data-warehouse-289815.salesforce_raw.College_Aspiration__c` AS CAP
        ON CA.Student__c = CAP.Student__c
LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt_asp #pull in college name in aspiration
        ON CAP.College_University__c = accnt_asp.id        
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` AS A_T
        ON CA.Student__c = A_T. Contact_Id 
        
WHERE C.grade_c = '12th Grade'
    AND C.College_Track_Status_Name = 'Current CT HS Student'
    AND AT_Record_Type_Name = 'High School Semester'
    AND A_T.indicator_years_since_hs_grad_to_date_c = -1.34 #11th Grade Spring Term
)

SELECT *
FROM filtered_data