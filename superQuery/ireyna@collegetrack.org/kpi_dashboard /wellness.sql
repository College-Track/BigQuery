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
        Ct.student_c,
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
            Attendance_Numerator_c, 
            co_vitality_scorecard_color_c,
            site_short,
            ct.student_c
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
    SUM(wellness_blue_red_num) AS wellness_blue_red_num,
    AVG(attended_wellness_sessions) AS avg_attended_sessions, #workshop session
    a.site_short
FROM gather_case_note_data as b
left join gather_wellness_attendance_data as a on a.site_short=b.site_short
GROUP BY 
    a.site_short
)

--Growth KPIs and students completing Covitality KPI
--prep_all_wellness_kpis AS (
SELECT
    A.site_short,
    wellness_covi_assessment_completed_ay,
    --wellness_survey_wellness_services_assisted_num,
   -- wellness_survey_wellness_services_assisted_denom,
    attended_wellness_sessions AS wellness_sum_attended_sessions,
    
FROM  students_that_completed_covi AS A