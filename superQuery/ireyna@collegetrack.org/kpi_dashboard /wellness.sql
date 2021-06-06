with gather_wellness_attendance_data AS (
    SELECT
        CASE
            WHEN co_vitality_scorecard_color_c IN ('Blue','Red')
            THEN 1
            ELSE 0
        END AS wellness_blue_red_num,
    --SUM(Attendance_Numerator_c) AS attended_wellness_sessions,#attended sessions from AT
    attendance_numerator_c AS attended_wellness_sessions,
        site_short
    FROM
        `data-warehouse-289815.salesforce_clean.class_template` CT
        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.AT_Id = CT.Academic_Semester_c
    WHERE
        Attendance_Numerator_c > 0
        AND department_c = 'Wellness'
        AND dosage_types_c NOT LIKE '%NSO%'
        AND ct.global_academic_semester_c IN (SELECT ct2.global_academic_semester_c
                                        FROM `data-warehouse-289815.salesforce_clean.class_template` CT2
                                        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT2 ON CAT2.AT_Id = CT.Academic_Semester_c
                                        WHERE AY_NAME = "AY 2020-21")

        AND grade_c != '8th Grade'
        AND Outcome_c != 'Cancelled'
        AND college_track_status_c = '11A'
    GROUP BY
            Attendance_Numerator_c, 
            co_vitality_scorecard_color_c,
            site_short
),
aggregate_wellness_sessions_from_attendance AS (
SELECT 
    Site_short,
    SUM(attended_wellness_sessions) AS sum_attended_wellness_sessions
FROM gather_wellness_attendance_data
GROUP BY
    site_short
),
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
)
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
--aggregate_case_note_data AS(
SELECT
    SUM(wellness_case_note_2020_21) AS wellness_case_notes, #wellness casenotes from 2020-21
    SUM(wellness_blue_red_num) AS wellness_blue_red_num,
    AVG(attended_wellness_sessions) AS avg_attended_sessions, #workshop session
    sum_attended_wellness_sessions,
    a.site_short
FROM gather_case_note_data as b
left join gather_wellness_attendance_data as a on a.site_short=b.site_short
left join aggregate_wellness_sessions_from_attendance as c on c.site_short=b.site_short
GROUP BY 
    a.site_short,
    attended_wellness_sessions