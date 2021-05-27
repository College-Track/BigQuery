-- SELECT
--   site_short,
--   Class_Attendance_Id,
--   Outcome_c
-- FROM
--   `data-warehouse-289815.salesforce_clean.class_template` CT
--   LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.AT_Id = CT.Academic_Semester_c
-- WHERE
--   Outcome_c = 'Scheduled'
--   AND (
--     EXTRACT(
--       MONTH
--       FROM
--         date_c
--     ) < EXTRACT(
--       MONTH
--       FROM
--         CURRENT_DATE()
--     )
--   )
--   AND current_as_c = true
--   AND CT.is_deleted = false


SELECT *
FROM `data-warehouse-289815.salesforce_clean.class_template`
WHERE Class_Attendance_Id = 'a2z1M000000eAwXQAU'