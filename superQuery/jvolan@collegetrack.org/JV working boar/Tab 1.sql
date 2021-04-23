SELECT
    id AS task_id,
    what_id,
    owner_id,
    created_by_id,
    created_date,
    who_id,
    
    FROM `data-warehouse-289815.salesforce.task`
    WHERE what_id LIKE '%(Semester)%'
    OR what_id LIKE '%(Quarter)%'