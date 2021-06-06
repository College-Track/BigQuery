gather_wellness_survey_data AS (
SELECT
    CT.site_short,
    S.contact_id AS students_receiving_wellness_services,
    
    CASE
        WHEN (
            working_with_college_track_wellness_services_has_assisted_you_in_managing_your_s IN ("Strongly Agree", "Totalmente de acuerdo")
            OR working_with_college_tracks_wellness_programming_has_helped_you_engage_in_self_c IN ("Strongly Agree", "Totalmente de acuerdo")
            OR working_with_college_tracks_wellness_services_has_enhanced_your_mental_health IN ("Strongly Agree", "Totalmente de acuerdo")
            )
        THEN 1
        ELSE 0
        END AS strongly_agree_wellness_services_assisted_them
        
FROM `data-studio-260217.surveys.fy21_hs_survey` S
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CT ON CT.Contact_Id = S.contact_id
WHERE did_you_engage_with_wellness_services_at_your_site = "Yes"
),

aggregate_wellness_survey_data AS (
SELECT 
    COUNT (DISTINCT students_receiving_wellness_services) AS wellness_survey_wellness_services_assisted_denom,
    SUM(strongly_agree_wellness_services_assisted_them) AS wellness_survey_wellness_services_assisted_num,
    site_short
FROM gather_wellness_survey_data 
GROUP BY site_short
),

#For KPI on average # of sessions for reb/blue Covi students 
#kpi: % of students/# of sessions/amt of time that students with red and blue CoVi scores have spent receiving support/counseling/coaching for their social emotional wellbeing health (either through a workshop, small group or 1:1s)
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
        AND ct.global_academic_semester_c IN (SELECT ct2.global_academic_semester_c
                                        FROM `data-warehouse-289815.salesforce_clean.class_template` CT2
                                        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT2 ON CAT2.AT_Id = CT.Academic_Semester_c
                                        WHERE AY_NAME = "AY 2020-21")

        AND grade_c != '8th Grade'
        AND Outcome_c != 'Cancelled'
        AND college_track_status_c = '11A'
    GROUP BY
            full_name_c,
            CAT.STUDENT_C, 
            co_vitality_scorecard_color_c,
            site_short