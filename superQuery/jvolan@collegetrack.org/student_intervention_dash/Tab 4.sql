SELECT
    Student__c,
    COUNT(DISTINCT Class__c) AS workshops_enrolled
    FROM `data-warehouse-289815.salesforce_raw.Class_Registration__c`
    WHERE Current_AT__c = TRUE
    AND Status__c = 'Enrolled'
    GROUP BY Student__c