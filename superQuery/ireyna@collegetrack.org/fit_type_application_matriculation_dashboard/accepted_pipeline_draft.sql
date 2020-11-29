WITH fit_type_acceptances AS #record count = 7870
(
SELECT
    contact_id AS contact_id_accepted,
    acceptance_group,
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
    acceptance_group AS acceptance_group_accepted
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
WHERE acceptance_group = "Accepted"

)

SELECT
    accept.*

FROM fit_type_acceptances AS accept
INNER JOIN `data-studio-260217.fit_type_pipeline.aggregate_data` AS agg
    ON agg.Contact_Id = Contact_Id_accepted


GROUP BY
    contact_id_accepted,
    accept.Full_Name__c,
    accept.College_Track_Status_Name,
    accept.High_School_Class,
    accept.site_full,
    accept.site_short,
    accept.region_full,
    accept.region_short,
    accept.college_app_id,
    accept.school_name_app,
    accept.admission_status__c,
    acceptance_group_accepted