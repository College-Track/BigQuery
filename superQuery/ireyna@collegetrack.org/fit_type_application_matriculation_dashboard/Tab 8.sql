SELECT count(contact_id), site_short, High_School_Class
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
group by site_short, High_School_Class