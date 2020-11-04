SELECT COUNT(Id), Workshop_Global_Academic_Year__c
FROM `data-warehouse-289815.salesforce_raw.Class_Attendance__c`
WHERE Workshop_Dosage_Type__c IS NULL 
GROUP BY Workshop_Global_Academic_Year__c