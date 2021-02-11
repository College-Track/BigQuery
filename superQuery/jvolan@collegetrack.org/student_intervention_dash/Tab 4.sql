SELECT
    Student__c,
    COUNT(class__c) AS workshops_enrolled
    FROM `data-warehouse-289815.salesforce_raw.Class_Registration__c`
    WHERE Status__c = 'Enrolled'
    AND Current_AT__c = TRUE
    GROUP BY Student__c