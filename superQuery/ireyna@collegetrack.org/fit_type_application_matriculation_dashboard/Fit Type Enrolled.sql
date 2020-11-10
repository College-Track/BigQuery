
CREATE OR REPLACE TABLE `data-studio-260217.fit_type_pipeline.fit_type_enrolled`
OPTIONS
    (
    description= "This table pulls college application, academic term Fall Year 1 data, and includes academic and demographic info. Table only includes students that applied and have an admission status of 'accepted and enrolled'"
    )
AS

SELECT

#pull in demographics, academics
    contact_id,
    Full_Name__c,
    College_Track_Status_Name,
    High_School_Class,
    Site_Text__c AS site_full,
    site_short,
    region AS region_full,
    region_short,
    GPA_Cumulative__c AS CGPA_11th,
    CASE
      WHEN GPA_Cumulative__c < 3 THEN "Below 3.0"
      WHEN GPA_Cumulative__c < 3.25 THEN "3.0 - 3.24"
      WHEN GPA_Cumulative__c >= 3.25 THEN "3.25+"
      ELSE "Missing"
    END AS CGPA_11th_bucket,
    Readiness_English_Official__c,
    Readiness_Math_Official__c,
    Readiness_Composite_Off__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    Indicator_Completed_CT_HS_Program__c,
    
#pull in college application data
    college_app_id,
    app.college_id,
    accnt.Name AS account_name,
    Type_of_School__c,
    Application_status__c,
    admission_status__c,
     CASE
        WHEN admission_status__c = "Accepted and Enrolled" THEN "Enrolled"
        ELSE "N/A"
        END AS pipeline_category,
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c,

#pull in AT data
    academic_term_id,
    academic_term_name,
    AT_Grade__c,
    ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    Indicator_College_Matriculation__c
    
    --Join with Account object to pull in name of School/College
    FROM `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
        ON app.college_id = accnt.id
    WHERE Indicator_Completed_CT_HS_Program__c = TRUE
    AND Application_status__c = "Applied"
    AND admission_status__c = "Accepted and Enrolled"
    AND High_School_Class >= 2017
    AND Indicator_Years_Since_HS_Grad_to_Date__c IN (.33,.25) #Fall Year 1 term