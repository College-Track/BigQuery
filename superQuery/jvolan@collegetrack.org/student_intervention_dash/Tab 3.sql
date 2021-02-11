SELECT
    Student__c,
    COUNT(Class__c) AS workshops_enrolled,
    Academic_Semester__c AS workshop_AT
    FROM `data-warehouse-289815.salesforce_raw.Class_Registration__c`
    WHERE Current_AT__c = TRUE
    AND Status__c = 'Enrolled'
    GROUP BY Student__c, Academic_Semester__c