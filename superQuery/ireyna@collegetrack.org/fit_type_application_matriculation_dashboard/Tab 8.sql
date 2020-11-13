SElect
    acct.Name,
    acct.Account_ID__c,
    app.College_University_18_Digit_ID__c,
    app.College_University__c
 FROm `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
 full join `data-warehouse-289815.salesforce_raw.Account` AS acct 
 ON acct.Account_ID__c= app.College_University__c
 WHERE acct.name = 'Metropolitan State University of Denver'