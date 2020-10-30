SELECT
    contact_id,
    Full_Name__c,
    High_School_Class__c,
    Site_Text__c AS site_full,
    site_short,
    region AS region_full,
    region_short,
    college_app_id,
    app.college_id,
    accnt.Name,
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c
    
    --Join with Account object to pull in name of School/College
    FROM college_application_AT AS app
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
    ON app.college_id = accnt.id
    
    GROUP BY
    contact_id,
    Full_Name__c,
    High_School_Class__c,
    site_full,
    site_short,
    region_full,
    region_short,
    college_app_id,
    app.college_id,
    accnt.Name,
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c