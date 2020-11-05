#just affiation id 

#test query to see if affiliation data comes through (not null) without referencing application_filtered table
SELECT
    Affiliation_Record_ID__c AS Affiliation_id,
    aff.id,
    npe5__Organization__c AS Affiliation_School_id,
    --aff.Situational_Fit_Type__c,
    --aff.Situational_Best_Fit_Context__c,
    --aff.Fit_Type_Current__c,
    --aff.Fit_Type__c AS fit_type_affiliation,
    --term.Fit_Type__c AS fit_type_affiliation_at,
    --aff.Best_Fit_Applied__c AS fit_type_start_of_affiliation

    FROM `data-warehouse-289815.sfdc_templates.contact_at_template` AS term
 --Join with Affiliation object
    LEFT JOIN `data-warehouse-289815.salesforce_raw.npe5__Affiliation__c` AS aff
        ON term.Affiliation_Record_ID__c = aff.Id

    --WHERE term.Indicator_Completed_CT_HS_Program__c = TRUE
        AND term.Indicator_Years_Since_HS_Grad_to_Date__c IN (.33,.25) #Fall Year 1 term
        --High_School_Class IN (2016, 2017, 2018, 2019, 2020) 
        --AND matri.RecordTypeId = "01246000000RNnTAAW" #College/University
        --AND Predominant_Degree_Awarded__c = "Predominantly bachelor's-degree granting"