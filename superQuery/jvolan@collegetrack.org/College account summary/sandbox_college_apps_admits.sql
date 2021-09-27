SELECT
    COUNT(ca.id) AS total_applications,
    a.name AS app_college_name,
    a.id AS app_college_id,
    
    
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean` ca
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON a.id = ca.college_university_c
    WHERE application_status_c = "Applied"
    GROUP BY app_college_name, app_college_id