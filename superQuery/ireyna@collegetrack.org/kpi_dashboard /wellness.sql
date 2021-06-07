 SELECT
        --Ct.student_c,
        CASE
            WHEN co_vitality_scorecard_color_c IN ('Blue','Red')
            THEN 1
            ELSE 0
        END AS wellness_blue_red_num,
    --SUM(Attendance_Numerator_c) AS attended_wellness_sessions,#attended sessions from AT
    SUM(attendance_numerator_c) AS attended_wellness_sessions,
        site_short
    FROM
        `data-warehouse-289815.salesforce_clean.class_template` CT
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
            --Attendance_Numerator_c, 
            co_vitality_scorecard_color_c,
            site_short