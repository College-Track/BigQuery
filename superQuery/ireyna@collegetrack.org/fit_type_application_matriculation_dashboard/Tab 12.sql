select count(College_Fit_Type_Applied__c), count(Fit_Type_Enrolled__c), count(fit_type_affiliation)
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`