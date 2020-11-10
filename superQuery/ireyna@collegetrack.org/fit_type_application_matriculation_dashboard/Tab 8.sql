SELECT  count(distinct contact_id),count(contact_id), CGPA_11th_bucket
FROM `data-studio-260217.fit_type_pipeline.aggregate_data`
where CGPA_11th_bucket = "3.0 - 3.24"
GROUP BY CGPA_11th_bucket