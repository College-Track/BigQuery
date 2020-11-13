SELECT A.Id, CA.Id
FROM `data-warehouse-289815.salesforce_raw.Account` A 
LEFT JOIN `data-warehouse-289815.salesforce_raw.College_Application__c` CA
ON A.Id = CA.College_University__c
WHERE A.Id = '0014600000uT26qAAC'