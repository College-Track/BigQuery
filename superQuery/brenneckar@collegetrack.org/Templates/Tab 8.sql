WITH workshop_template AS (
  SELECT
    CA.Id AS Class_Attendance_Id,
    CA.Student_c,
    CA.Absence_Reason_c,
    CA.Academic_Semester_c,
    CA.Attendance_Denominator_c,
    CA.Attendance_Excluded_c,
    CA.Attendance_Note_c,
    CA.Attendance_Numerator_c,
    CA.Attendance_c,
    CA.Formula_Total_Session_Hours_c,
    CA.Outcome_c,
    CA.Status_c,
    CA.Workshop_One_Time_Attendance_c,
    CA.Attendance_Numerator_excluding_make_up_c,
    CA.Attendance_Denominator_Excluding_Make_Up_c,
    CS.Id AS Class_Session_Id,
    CS.Class_c,
    CS.Attendance_Taker_c,
    CS.Cancelled_c,
    CS.Capacity_c,
    CS.date_c,
    CS.Notes_Wellness_c,
    C.department_c,
    C.dosage_types_c,
    C.site_c,
    C.workshop_instructor_c,
    C.attendance_excluded_c,
    C.attendance_taker_c,
    C.description_c,
    C.start_date_c,
    C.end_date_c,
    C.start_time_c,
    C.end_time_c,
    C.recurring_days_c,
    C.global_academic_semester_c,
    C.workshop_capacity_c,
    C.status_c AS class_status,
    C.sessions_c,
    C.enrolled_students_c,
    GAT.name AS GAT_Name
  FROM
    `data-warehouse-289815.salesforce.class_attendance_c` CA
    LEFT JOIN `data-warehouse-289815.salesforce.class_session_c` CS ON CA.Class_Session_c = CS.Id
    LEFT JOIN `data-warehouse-289815.salesforce.class_c` C ON CS.Class_c = C.Id
    LEFT JOIN `data-warehouse-289815.salesforce.global_academic_semester_c` GAT ON C.global_academic_semester_c = GAT.Id
  WHERE
    GAT.start_date_c >= "2018-09-01"
)
SELECT
  GAT_Name,
  Count(Class_Attendance_Id)
FROM
  workshop_template
GROUP BY
  GAT_Name