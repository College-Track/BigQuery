/*
SELECT COUNT(contact_id) AS COUNT_STUDENT, Full_Name__c, High_School_Class, College_Fit_Type_Applied__c, college_app_id
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
WHERE College_Fit_Type_Applied__c = "Best Fit" AND High_School_Class >= 2016 AND site_short ="Oakland"
GROUP BY Full_Name__c, High_School_Class, College_Fit_Type_Applied__c, college_app_id
*/
SELECT COUNT(contact_id) AS COUNT_STUDEN
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
WHERE College_Fit_Type_Applied__c = "Best Fit" AND High_School_Class >= 2016 AND site_short ="Oakland"