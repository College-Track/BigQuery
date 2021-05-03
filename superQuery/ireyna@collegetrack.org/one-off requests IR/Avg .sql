WITH acceptance_by_student AS
(SELECT 
    contact_id,
    site_short,
    CASE 
        WHEN college_accepted_app_id IS NOT NULL THEN 1
        ELSE 0
    END AS accepted_count
FROM `data-studio-260217.college_applications.college_application_filtered_table`
GROUP BY 
contact_id,
site_short,
college_accepted_app_id
-- site_short = 'Watts'
)

SELECT site_short,SUM(accepted_count)
FROM acceptance_by_student
GROUP BY site_short