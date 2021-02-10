WITH gather_data AS (SELECT subject, who_id, description, C.site_short
FROM `data-warehouse-289815.salesforce.task` T
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON C.Contact_Id = who_id
WHERE subject LIKE '%CT Corporate Residency Summer%' AND C.region_short = 'Colorado'
AND T.is_deleted = false
)

SELECT *
FROM gather_data