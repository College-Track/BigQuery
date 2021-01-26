WITH gather_student_data AS (
  SELECT
    Contact_Id,
    site_short,
    College_Track_Status_Name,
    high_school_graduating_class_c,
    grade_c,
    full_name_c,
    email,
    Most_Recent_GPA_Cumulative_c,
    most_recent_gpa_semester_c,
    total_bank_book_balance_contact_c,
    community_service_hours_c,
    Attendance_Rate_Current_AS_c,
    Current_HS_CT_Coach_c,
    community_service_form_link_c,
    summer_experience_form_link_c,
    current_academic_semester_c,
    previous_academic_semester_c,
    attendance_rate_previous_term_c,
    CASE
      WHEN (attended_workshops_c - enrolled_sessions_c) > 0 THEN 0
      ELSE ABS((attended_workshops_c - enrolled_sessions_c))
    END AS workshops_to_make_up
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    college_track_status_c IN ('11A', '18a', '12A')
    AND current_as_c = true
),
gather_workshop_data AS (
  SELECT
    C.student_c,
    C.workshop_display_name_c,
    FORMAT_TIME('%l:%M', PARSE_TIME('%X.000Z', C.start_time_c)) AS start_time_c,
    C.recurring_days_c,
    C.class_status,
    C.Academic_Semester_c,
    SUM(C.Attendance_Numerator_c) AS attended_sessions,
    SUM(C.Attendance_Denominator_c) AS enrolled_sessions,
    CASE
      WHEN SUM(C.Attendance_Denominator_c) = 0 THEN NULL
      ELSE SUM(C.Attendance_Numerator_c) / SUM(C.Attendance_Denominator_c)
    END AS attendance_rate
  FROM
    `data-warehouse-289815.salesforce_clean.class_template` C
    LEFT JOIN `data-warehouse-289815.salesforce.class_registration_c` CR ON CR.class_c = C.class_c
    AND CR.student_c = C.student_c
  WHERE
    CR.status_c = 'Enrolled'
  GROUP BY
    student_c,
    workshop_display_name_c,
    start_time_c,
    recurring_days_c,
    class_status,
    Academic_Semester_c
),
gather_test_data AS (
  SELECT
    T.contact_name_c,
    -- RT.Name,
    -- CASE WHEN version_c = 'Official' THEN 'Official'
    -- WHEN version_c = 'Entrance into CT Diagnostic' THEN "Diagnostic"
    -- WHEN version_c = 'End of Year Diagnostic' THEN 'Diagnostic'
    -- ELSE "Other"
    -- END AS version_c,
    MAX(T.act_composite_score_c) as max_act_composite,
    MAX(T.sat_total_score_c) AS max_sat_total,
    MAX(T.act_english_c) AS max_act_english,
    MAX(T.act_mathematics_c) AS max_act_math,
    MAX(T.sat_math_c) AS max_sat_math,
    MAX(T.sat_reading_writing_c) AS max_sat_english
  FROM
    `data-warehouse-289815.salesforce.test_c` T
    LEFT JOIN `data-warehouse-289815.salesforce.record_type` RT on RT.id = T.record_type_id
  WHERE
    status_c = 'Completed'
    AND is_deleted = false
    AND RT.Name IN ('SAT', 'ACT')
  GROUP BY
    T.contact_name_c -- RT.Name
    -- version_c
)
SELECT
  GSD.*,
  GWD.*
EXCEPT
  (student_c, academic_semester_c),
  GTD.max_act_composite,
  GTD.max_act_english,
  GTD.max_act_math,
  GTD.max_sat_total,
  GTD.max_sat_english,
  GTD.max_sat_math,
FROM
  gather_student_data GSD
  LEFT JOIN gather_workshop_data GWD ON GSD.Contact_Id = GWD.Student_c
  AND GSD.previous_academic_semester_c = GWD.Academic_Semester_c
  LEFT JOIN gather_test_data GTD ON GTD.contact_name_c = GSD.Contact_Id