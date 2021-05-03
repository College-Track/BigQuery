--SUM Of acceptances
WITH gather_students AS
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

prep_aggregation_of_acceptances AS (

SELECT contact_id,site_short,SUM(accepted_count) AS sum_acceptances
FROM gather_students
--WHERE accepted_count = 1
GROUP BY contact_id, site_short
)

SELECT avg(sum_Acceptances) AS avg, 
from prep_aggregation_of_acceptances
--GROUP BY contact_id