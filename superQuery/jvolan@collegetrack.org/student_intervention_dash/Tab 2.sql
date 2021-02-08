SELECT
    WhoId,
    WhatId,
    ActivityDate AS Date,
    Subject,
    Description
    FROM `data-warehouse-289815.salesforce_raw.Task`
    WHERE CreatedDate BETWEEN DATE_SUB(CURRENT_DATE(),INTERVAL 6 MONTH) AND CURRENT_DATE()