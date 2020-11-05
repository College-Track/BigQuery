#affiliation with raw academic term object to test successful JOIN
SELECT 
    term.id,
    term.Affiliation__c,
    aff.id,
    term.Name,
    term.Fit_Type__c AS fit_type_affiliation_at,
    aff.Fit_Type__c AS fit_type_affiliation,
    aff.Best_Fit_Applied__c AS fit_type_start_of_affiliation,
    aff.Fit_Type_Current__c,
    aff.Situational_Fit_Type__c,
    --aff.Situational_Best_Fit_Context__c,
    npe5__Organization__c AS Affiliation_School_id
    

FROM `data-warehouse-289815.salesforce_raw.Academic_Semester__c` as term
LEFT JOIN `data-warehouse-289815.salesforce_raw.npe5__Affiliation__c` AS aff
    ON term.Affiliation__c = aff.id