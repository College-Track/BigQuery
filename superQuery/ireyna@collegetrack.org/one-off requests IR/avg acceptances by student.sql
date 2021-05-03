--SUM Of acceptances
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
),

sum_of_acceptances AS (

SELECT contact_id,site_short,SUM(accepted_count) AS sum_acceptances
FROM acceptance_by_student
GROUP BY contact_id, site_short
)

SELECT contact_id, avg(sum_Acceptances) AS avg, 
from sum_of_acceptances
GROUP BY contact_id