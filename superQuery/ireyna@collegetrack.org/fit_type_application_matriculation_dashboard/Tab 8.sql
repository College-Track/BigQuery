SELECT distinct count(contact_id), CGPA_11th_bucket
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
where CGPA_11th_bucket = "Below 2.5"
GROUP BY CGPA_11th_bucket