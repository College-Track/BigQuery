SELECT COUNT(Id), Academic_Semester__c
FROM `data-warehouse-289815.salesforce_raw.Class_Attendance__c`
WHERE Workshop_Dosage_Type__c IS NULL AND Academic_Semester__c = 'a1a1M000003FOP8QAO'
GROUP BY Academic_Semester__c