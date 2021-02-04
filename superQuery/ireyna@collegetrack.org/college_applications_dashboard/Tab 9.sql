CREATE OR REPLACE TABLE `data-studio-260217.college_applications.College_application_senior_count`
OPTIONS
    (
    description= "senior count by site"
    )
AS

With senior_aggregate_count AS

(SELECT site_short, contact_id

FROM `data-warehouse-289815.salesforce_clean.college_application_clean` AS app
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` AS C   
ON app.student_c = C.Contact_Id

WHERE C.grade_c = '12th Grade'
AND C.College_Track_Status_Name = 'Current CT HS Student'
#AND site_short = 'Aurora'

group by
site_short,
contact_id
)

SELECT site_short, count (distinct contact_id) AS total_senior_count
FROM senior_aggregate_count
group by site_short