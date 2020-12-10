SELECT contact_id, full_name_c, count(distinct college_app_id)
FROM `data-studio-260217.college_applications.college_application_filtered_table`
group by contact_id, full_name_c