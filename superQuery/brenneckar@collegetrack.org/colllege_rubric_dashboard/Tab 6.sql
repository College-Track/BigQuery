SELECT Affiliation__c, Affiliation_Record_ID__c,  A.Id, AS Affiliation_Id, A_S.Id as AT_Id
FROM `data-warehouse-289815.salesforce_raw.Academic_Semester__c` A_S
LEFT JOIN `data-warehouse-289815.salesforce_raw.npe5__Affiliation__c` A ON A.Id =  Affiliation__c
LIMIT 1000