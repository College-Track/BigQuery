with gather_wellness_attendance_data AS ( --prep for SUM of sessions to validate data
SELECT
    attendance_numerator_c AS attended_wellness_sessions,
    site_short
    FROM `data-warehouse-289815.salesforce_clean.class_template` CT
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.AT_Id = CT.Academic_Semester_c
    WHERE
        Attendance_Numerator_c > 0
        AND department_c = 'Wellness'
        AND dosage_types_c NOT LIKE '%NSO%'
        AND AY_NAME = "AY 2020-21"
        AND grade_c != '8th Grade'
        AND Outcome_c != 'Cancelled'
        AND college_track_status_c = '11A'
    GROUP BY
            site_short,
            Attendance_Numerator_c
),
prep_attedance_data_for_avg AS (
SELECT
    ct.student_c,
    SUM(attendance_numerator_c) AS sum_attended_wellness_by_student,
    site_short
FROM `data-warehouse-289815.salesforce_clean.class_template` CT
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.AT_Id = CT.Academic_Semester_c
WHERE
        Attendance_Numerator_c > 0
        AND department_c = 'Wellness'
        AND dosage_types_c NOT LIKE '%NSO%'
        AND AY_NAME = "AY 2020-21"
        AND grade_c != '8th Grade'
        AND Outcome_c != 'Cancelled'
        AND college_track_status_c = '11A'
GROUP BY
    ct.student_c,
    site_short
)
#gather case load data
gather_case_note_data AS (
SELECT 
    CASE
        WHEN id IS NOT NULL 
        THEN 1
        ELSE 0
    END AS wellness_case_note_2020_21,
    id AS case_note_id, #case note id
    site_short
    
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
LEFT JOIN `data-warehouse-289815.salesforce.progress_note_c`CSE  ON CAT.AT_Id = CSE.Academic_Semester_c
WHERE Type_Counseling_c = TRUE
    AND AY_name = 'AY 2020-21'
GROUP BY
    site_short,
    id
),
/*
aggregate_wellness_session_data AS(
SELECT
    SUM(wellness_blue_red_num) AS wellness_blue_red_num,
    AVG(attended_wellness_sessions) AS avg_attended_sessions, #workshop sessions
    site_short
FROM gather_wellness_attendance_data
GROUP BY 
    site_short
)*/
aggregate_kpis_data AS(
SELECT
    SUM(wellness_case_note_2020_21) AS wellness_case_notes, #wellness casenotes from 2020-21
    --SUM(wellness_blue_red_num) AS wellness_blue_red_num,
    AVG(sum_attended_wellness_by_studen) AS avg_attended_sessions, #workshop session
    SUM(attended_wellness_sessions) AS attended_wellness_sessions,
    a.site_short
FROM gather_case_note_data as b
left join gather_wellness_attendance_data as a on a.site_short=b.site_short
LEFT JOIN prep_attendance_data_for_avg as c a.site_short=c.site_short
GROUP BY 
    a.site_short