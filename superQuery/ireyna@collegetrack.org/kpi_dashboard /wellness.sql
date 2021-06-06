with gather_wellness_attendance_data AS (
    SELECT
        CAT.student_c,
        full_name_c,
        CASE
        WHEN co_vitality_scorecard_color_c IN ('Blue','Red')
        THEN 1
        ELSE 0
    END AS wellness_blue_red_num,
    SUM(Attendance_Numerator_c) AS attended_wellness_sessions, #attended sessions from AT
        site_short
    FROM
        `data-warehouse-289815.salesforce_clean.class_template` CT
        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.AT_Id = CT.Academic_Semester_c
    WHERE
        Attendance_Numerator_c > 0
        AND department_c = 'Wellness'
        AND dosage_types_c NOT LIKE '%NSO%'
        AND global_academic_semester_c IN 
                                        (SELECT AY_NAME
                                        FROM `data-warehouse-289815.salesforce_clean.contact_at_template` CAT2
                                        LEFT JOIN `data-warehouse-289815.salesforce.progress_note_c`CSE2  ON CAT.AT_Id = CSE.Academic_Semester_c
                                        WHERE AY_NAME = "AY 2020-21")
        AND grade_c != '8th Grade'
        AND Outcome_c != 'Cancelled'
        AND college_track_status_c = '11A'
    GROUP BY
            full_name_c,
            CAT.STUDENT_C, 
            co_vitality_scorecard_color_c,
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