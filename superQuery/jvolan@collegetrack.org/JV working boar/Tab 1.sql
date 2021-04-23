WITH get_AT_data AS
(
    SELECT
    AT_Id,
    AT_Name,
    full_name_c,
    student_c AS contact_id

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
    who_id AS name,
    get_AT_data.AT_Id,
    get_AT_data.AT_Name,
    get_AT_data.contact_id,
    get_AT_data.full_name_c
    
    FROM `data-warehouse-289815.salesforce.task`
    LEFT JOIN get_AT_data ON get_AT_data.AT_Id = what_id
)

    SELECT
    *,

    FROM get_tasks_missing_student
    WHERE name IS NULL
    AND 
    (AT_Name LIKE '%(Semester)%'
    OR AT_Name LIKE '%(Quarter)%')