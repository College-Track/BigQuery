SELECT count(contact_id), site_short
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
where AT_Enrollment_Status__c in ("Full-time","Part-time", "Approved Gap Year")
group by site_short