SELECT COUNT(contact_id) AS COUNT_STUDENT, College_Fit_Type_Applied__c, college_app_id
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
WHERE College_Fit_Type_Applied__c = "Best Fit"
GROUP BY College_Fit_Type_Applied__c, college_app_id