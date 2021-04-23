WITH get_tasks_missing_student AS
(
    SELECT
    id AS task_id,
    what_id,
    owner_id,
    created_by_id,
    created_date,
    who_id,
    
    
    FROM `data-warehouse-289815.salesforce.task`
),

AT_match AS
(
    SELECT
    AT_Id,
    student_c,
    get_tasks_missing_student.*,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN get_tasks_missing_student ON what_id = AT_Id
    
)

    SELECT
    *
    FROM AT_match