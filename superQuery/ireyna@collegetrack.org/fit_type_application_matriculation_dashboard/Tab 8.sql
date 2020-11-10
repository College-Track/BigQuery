SELECT count(distinct contact_id), count(fit_type_affiliation) AS fit_aff, count(Fit_Type_Enrolled__c) AS fit_enrolled, count(College_Fit_Type_Applied__c) AS fit_applied, site_short
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
group by site_short