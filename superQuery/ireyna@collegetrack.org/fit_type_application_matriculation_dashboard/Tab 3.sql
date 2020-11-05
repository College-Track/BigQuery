SELECT COUNT(contact_id) AS COUNT_STUDENT, High_School_Class, College_Fit_Type_Applied__c, college_app_id
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
WHERE College_Fit_Type_Applied__c = "Best Fit" AND High_School_Class >= 2016
GROUP BY High_School_Class, College_Fit_Type_Applied__c, college_app_id