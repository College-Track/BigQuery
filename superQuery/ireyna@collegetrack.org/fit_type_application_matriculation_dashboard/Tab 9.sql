
SELECT
    term.contact_id,
    term.Full_Name__c,
    High_School_Class,
    term.Site_Text__c AS site_full,
    term.site_short,
    term.region AS region_full,
    term.region_short,
    AT_Name AS academic_term_name,
    term.AT_Id AS academic_term_id,
    term.AT_Grade__c,
    student_audit_status__c AS ct_status_at,
    term.Indicator_Years_Since_HS_Grad_to_Date__c,
    term.School_Name,
    term.School_Predominant_Degree_Awarded__c,
    Affiliation_Record_ID__c AS Affiliation_id,
    npe5__Organization__c AS Affiliation_School_id,
    aff.Situational_Fit_Type__c,
    --aff.Situational_Best_Fit_Context__c,
    aff.Fit_Type_Current__c,
    aff.Fit_Type__c AS fit_type_affiliation,
    term.Fit_Type__c AS fit_type_affiliation_at,
    aff.Best_Fit_Applied__c AS fit_type_start_of_affiliation

--Join to align AT data with available college application data
    FROM `data-warehouse-289815.sfdc_templates.contact_at_template` AS term
    RIGHT JOIN `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
      ON app.contact_id = term.contact_id

 --Join with Affiliation object to pull in Fit Type (Start of Affiliation) for older students
    FULL JOIN `data-warehouse-289815.salesforce_raw.npe5__Affiliation__c` AS aff
        ON term.Affiliation_Record_ID__c = aff.Id

    WHERE term.Indicator_Completed_CT_HS_Program__c = TRUE
        AND term.Indicator_Years_Since_HS_Grad_to_Date__c IN (.33,.25) #Fall Year 1 term
        --High_School_Class IN (2016, 2017, 2018, 2019, 2020) 
        --AND matri.RecordTypeId = "01246000000RNnTAAW" #College/University
        --AND Predominant_Degree_Awarded__c = "Predominantly bachelor's-degree granting"