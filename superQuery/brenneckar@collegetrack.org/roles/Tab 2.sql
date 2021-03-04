WITH gather_groups AS (SELECT 
Id, Name
FROM `data-warehouse-289815.salesforce.group`
WHERE name LIKE "%Shared CC Advising%"
)

gather_group_members AS (
SELECT *
FROM `data-warehouse-289815.salesforce.group_member`
)

SELECT *
FROM gather_group_members