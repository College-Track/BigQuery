WITH gather_groups AS (SELECT 
Id
FROM `data-warehouse-289815.salesforce.group`
WHERE name LIKE "%Shared CC Advising%"
),

gather_group_members AS (
SELECT user_or_group_id, group_id
FROM `data-warehouse-289815.salesforce.group_member`
WHERE group_id IN (SELECT Id FROM gather_groups)

)

SELECT *
FROM gather_group_members