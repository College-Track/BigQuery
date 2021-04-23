WITH get_AT_data AS
(
    SELECT
    AT_Id,
    student_c,

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE college_track_status_c = '15A'
),

get_tasks_missing_student AS
(
    SELECT
    id AS task_id,
    what_id,
    owner_id,
    created_by_id,
    created_date,
    who_id,
    
    
    FROM `data-warehouse-289815.salesforce.task`
    WHERE who_id IS NULL
    AND (what_id LIKE '%(Semester)%'
    OR what_id LIKE '%(Quarter)%')
)

    SELECT
    *,
    get_AT_data.student_c
    
    FROM get_tasks_missing_student
    LEFT JOIN get_AT_data ON get_AT_data.AT_Id = what_id