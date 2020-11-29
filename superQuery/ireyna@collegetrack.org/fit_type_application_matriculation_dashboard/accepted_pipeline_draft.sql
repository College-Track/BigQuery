SELECT
    count(contact_id) AS contact_id_accepted,
    /*acceptance_group,
    contact_id,
    Full_Name__c,
    College_Track_Status_Name,
    High_School_Class,
    site_full,
    site_short,
    region_full,
    region_short,
    college_app_id,
    school_name_app,
    admission_status__c,
    acceptance_group AS acceptance_group_accepted*/
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
WHERE acceptance_group = "Accepted"