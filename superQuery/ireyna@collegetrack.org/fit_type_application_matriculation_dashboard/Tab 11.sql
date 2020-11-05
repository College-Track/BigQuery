SELECT aff.Fit_Type__c AS fit_type_affiliation,
    aff.Best_Fit_Applied__c AS fit_type_start_of_affiliation,
    aff.Fit_Type_Current__c,
    aff.Situational_Fit_Type__c
FROM `data-warehouse-289815.salesforce_raw.npe5__Affiliation__c` AS aff
WHERE id = "a0H1M000014P00eUAC"