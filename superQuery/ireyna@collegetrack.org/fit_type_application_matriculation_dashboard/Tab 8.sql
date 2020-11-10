SELECT count(fit_type_affiliation), count(Fit_Type_Enrolled__c), count(College_Fit_Type_Applied__c), site_short
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
group by site_short