SELECT DISTINCT contact_id, site_short, High_School_Class
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
where AT_Enrollment_Status__c in ("Full-time","Part-time", "Approved Gap Year")
AND site_short="Oakland"
group by contact_id, site_short, High_School_Class