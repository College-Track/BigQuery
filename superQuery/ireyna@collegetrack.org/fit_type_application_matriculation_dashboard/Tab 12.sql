select High_School_Class, College_Fit_Type_Applied__c
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
GROUP BY 
High_School_Class, College_Fit_Type_Applied__c