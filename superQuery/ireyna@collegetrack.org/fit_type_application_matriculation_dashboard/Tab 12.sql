select count(College_Fit_Type_Applied__c), count(Fit_Type_Enrolled__c), count(fit_type_affiliation), Full_Name__c, contact_id
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
GROUP BY
Full_Name__c, contact_id