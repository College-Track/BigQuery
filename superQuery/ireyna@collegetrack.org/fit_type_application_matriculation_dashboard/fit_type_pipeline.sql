CREATE OR REPLACE TABLE `data-studio-260217.fit_type_pipeline.pipeline_data`
OPTIONS
    (
    description= "This table joins the fit type applications table with fit type matriculation table (application, acceptances, enrollment, matriculated)."
    )
AS

SELECT 
app.*
    EXCEPT (fit_type_enrolled),
term.*
    EXCEPT (Full_Name__c,site_full,site_short,region_full,region_short,contact_id)

FROM `data-studio-260217.fit_type_pipeline.fit_type_applications` AS app    
LEFT JOIN `data-studio-260217.fit_type_pipeline.fit_type_matriculation` AS term
    ON app.contact_id = term.contact_id
    
GROUP BY
    contact_id,
    Full_Name__c,
    College_Track_Status_Name,
    High_School_Class,
    site_full,
    site_short,
    region_full,
    region_short,
    CGPA_11th,
    CGPA_11th_bucket,
    Readiness_English_Official__c,
    Readiness_Math_Official__c,
    Readiness_Composite_Off__c,
    Indicator_Persisted_into_2nd_Year_CT__c,
    Indicator_Persisted_into_Year_2_Wide__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    FA_Req_Expected_Financial_Contribution__c,
    EFC_bucket,
    Indicator_Completed_CT_HS_Program__c,
    college_app_id,
    college_id,
    account_id,
    school_name_app,
    school_name_enrolled,
    school_type_enrolled,
    Type_of_School__c,
    Application_status__c,
    admission_status__c,
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c,
    fit_type_enrolled_chart,
    school_name_accepted,
    school_name_accepted_enrolled,
    fit_type_applied_accepted,
    acceptance_group_accepted,
    High_School_Class__c,
    academic_term_name,
    academic_term_id,
    AT_Grade__c,
    ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    Indicator_College_Matriculation__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    AT_Enrollment_Status__c,
    Affiliation_School_id,
    Situational_Fit_Type__c,
    Situational_Best_Fit_Context__c,
    Fit_Type_Current__c,
    Fit_Type__c,
    fit_type_start_of_affiliation,
    Affiliation_id_at,
    id_aff,
    fit_type_affiliation