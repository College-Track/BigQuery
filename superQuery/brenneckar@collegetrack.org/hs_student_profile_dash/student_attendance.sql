WITH gather_attendance_data AS (
  SELECT
    Student_c AS Contact_Id,
    EXTRACT(
      ISOWEEK
      FROM
        date_c
    ) as date_week,
    CONCAT(
      "Week ",
      CAST(
        EXTRACT(
          ISOWEEK
          FROM
            date_c
        ) AS STRING
      )
    ) as string_date_week,
    workshop_display_name_c,
    academic_semester_c,
    SUM(Attendance_Numerator_c) AS Attendance_Numerator_c,
    SUM(Attendance_Denominator_c) AS Attendance_Denominator_c,
  FROM
    `data-warehouse-289815.salesforce_clean.class_template`
  WHERE
    date_c <= CURRENT_DATE()
  GROUP BY
    Student_c,
    EXTRACT(
      ISOWEEK
      FROM
        date_c
    ),
    CONCAT(
      "Week ",
      CAST(
        EXTRACT(
          ISOWEEK
          FROM
            date_c
        ) AS STRING
      )
    ),
    workshop_display_name_c,
    academic_semester_c
),
join_data AS (
  SELECT
    GAD.*,
    SLTT.current_as_c
  FROM
    gather_attendance_data GAD
    LEFT JOIN `data-studio-260217.hs_student_profile_dashboard.student_term_table` SLTT ON SLTT.Contact_Id = GAD.Contact_Id
    AND SLTT.AT_Id = GAD.academic_semester_c
)
SELECT
  *
FROM
  join_data