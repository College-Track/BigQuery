SELECT
    app.*,
    term.*
        EXCEPT (Full_Name__c,High_School_Class__c,site_full,site_short,region_full,region_short,Contact_Id)

FROM fit_type_application AS app

--Join academic term data (matriculation table) to college application data
LEFT JOIN fit_type_matriculation AS term
    ON app.Contact_Id = term.Contact_Id
--WHERE APP.High_School_Class IN (2016, 2017, 2018, 2019, 2020)   

GROUP BY
    app.contact_id,
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
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    Indicator_Completed_CT_HS_Program__c,
    college_app_id,
    app.college_id,
    account_name,
    Type_of_School__c,
    Application_status__c,
    admission_status__c,
    acceptance_group,
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c,
    academic_term_name,
    academic_term_id,
    AT_Grade__c,
    ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    Affiliation_School_id,
    Situational_Fit_Type__c,
    Situational_Best_Fit_Context__c,
    Fit_Type_Current__c,
    fit_type_affiliation,
    fit_type_affiliation_at,
    fit_type_start_of_affiliation,
    Affiliation_id_at,
    id_aff