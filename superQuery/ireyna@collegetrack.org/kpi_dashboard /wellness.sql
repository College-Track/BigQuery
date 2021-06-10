-- The denominator for this metric will be students who answered "yes" to receiving wellness services
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


--Average # of sessions for reb/blue Covi students or 1:1 (case notes)
--% of students/# of sessions/amt of time that students with red and blue CoVi scores have spent receiving support/counseling/coaching for their social emotional wellbeing health (either through a workshop, small group or 1:1s)
--Broken down into various CTEs to gather students with red/blue covi, wellness sessions attended, and case notes logged

--Pulling students with red/blue covi from academic term (2020-21AY)
with gather_red_blue_covi_at AS ( 
SELECT
        student_c,
        site_short,
        AY_Name,
        MAX(CASE
            WHEN co_vitality_scorecard_color_c IN ('Blue','Red')
            THEN 1
            ELSE NULL
        END) AS wellness_blue_red_denom
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE grade_c != '8th Grade'
    AND college_track_status_c = '11A'
    AND AY_NAME = "AY 2020-21"
    AND Term_c = "Fall"
    AND grade_c != '8th Grade'
    AND co_vitality_scorecard_color_c IN ('Blue','Red')
GROUP BY 
    student_c,
    site_short,
    AY_Name
),

--Sum students that have a red or blue covitality color at some point during 2020-21AY
sum_of_blue_red_covi AS (
SELECT
        site_short,
        SUM(wellness_blue_red_denom) AS sum_of_blue_red_covi_for_avg #students with blue/red Covitality scorecard colors for denominator
FROM gather_red_blue_covi_at
GROUP BY site_short
),

--gather Wellness sessions attended during 2020-21
gather_wellness_attendance_data AS (
SELECT
    SUM(attendance_numerator_c) AS sum_attended_wellness_sessions,
    site_short,
    RB.student_c
   
    FROM gather_red_blue_covi_at AS RB
    LEFT JOIN `data-warehouse-289815.salesforce_clean.class_template` AS CT ON RB.student_c = CT.student_c
    WHERE
        Attendance_Numerator_c > 0
        AND department_c = 'Wellness'
        AND dosage_types_c NOT LIKE '%NSO%'
        AND Outcome_c != 'Cancelled'
        AND AY_NAME = "AY 2020-21"
    GROUP BY
            site_short,
            student_c
)

SELECT sum_attended_wellness_sessions, site_short 
FROM gather_wellness_attendance_data
GROUP BY site_short