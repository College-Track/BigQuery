SELECT
    WhoId,
    WhatId AS Related_to,
    ActivityDate AS Date,
    Subject,
    Description,
    X18_Digit_Activity_ID__c,
    Reciprocal_Communication__c
    
    FROM `data-warehouse-289815.salesforce_raw.Task`
    WHERE CreatedDate BETWEEN DATE_SUB(CURRENT_DATE(),INTERVAL 12 MONTH) AND CURRENT_DATE()