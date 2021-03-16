WITH gather_attendance_data AS (
  SELECT
    Student_c,
    Attendance_Numerator_c,
    Attendance_Denominator_c,
    global_academic_semester_c,
    date_c,
    workshop_display_name_c,
    academic_semester_c
  FROM
    `data-warehouse-289815.salesforce_clean.class_template`
),
join_data AS (
  SELECT
    GAD.*
  FROM
    gather_attendance_data GAD
    LEFT JOIN `data-studio-260217.hs_student_profile_dashboard.student_term_table` SLTT ON SLTT.Contact_Id = GAD.Student_c
    AND SLTT.AT_Id = GAD.academic_semester_c
)
SELECT
  *
FROM
  join_data