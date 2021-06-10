SELECT
    SUM(attendance_numerator_c) AS sum_attended_wellness_sessions,
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
        AND contact_id IN (SELECT contact_id FROM `data-warehouse-289815.salesforce_clean.contact_at_template` where co_vitality_scorecard_color_c IN  ('Blue','Red') AND AY_name = "AY 2020-21" AND Term_c = "Fall")
    GROUP BY
            site_short