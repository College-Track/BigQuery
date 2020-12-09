#college applications for current academic year, graduating HS class

WITH filtered_college_applications AS #compile college application, contact data
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

#data from Contact - demo, academic dara   
    C.full_name_c,
    C.Gender_c ,
    C.Ethnic_background_c ,
    C.indicator_low_income_c,
    C.first_generation_fy_20_c, 
    C.site_short,
    C.region_short,
    C.readiness_english_official_c,
    C.readiness_composite_off_c,
    C.readiness_math_official_c 
    
    
FROM `data-warehouse-289815.salesforce_raw.College_Application__c` AS CA 
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` AS C
        ON CA.Student__c = C.Contact_Id
LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt #to pull in college name
        ON CA.College_University__c = accnt.id
)

SELECT *
FROM filtered_college_applications
LIMIT 50