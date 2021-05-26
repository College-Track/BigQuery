/*
CREATE OR REPLACE TABLE `data-studio-260217.kpi_dashboard.student_life` 
OPTIONS
    (
    description= "Aggregating Student Life KPI metrics for the Data Studio KPI dashboard"
    )
AS
*/

WITH gather_contact_data AS(
    SELECT
        contact_id,
        site_short,
        high_school_graduating_class_c,
        Dream_Statement_filled_out_c,
        CASE
            WHEN (Dream_Statement_filled_out_c = True  
            AND college_track_status_c = '11A')
            THEN 1
            ELSE  0 
            END AS dream_declared
            
    FROM `data-warehouse-289815.salesforce_clean.contact_template` AS C
    WHERE (college_track_status_c = '11A' OR indicator_completed_ct_hs_program_c = TRUE)

),

--pull in students that have at least 1 workshop attendance session in Fall/Spring, or were active in Summer
--this indicates some threshold of participation in programming, even if attendance numerator < 1
set_mse_reporting_group AS (
SELECT 
    CAT.student_c,
    site_short
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` CAT    
LEFT JOIN `data-warehouse-289815.salesforce_clean.class_template` CT
ON CAT.contact_id = CT.student_c

--pull in students that have a session attendance record in Fall/Spring 2019-20, excluding NSO 
WHERE site_short <> "College Track Arlen"
    AND (Attendance_Denominator_c IS NOT NULL
    AND dosage_types_c NOT LIKE '%NSO%'
    AND AY_Name = "AY 2019-20"
    AND term_c IN ("Fall","Spring")
    AND grade_c != '8th Grade'
    AND (CAT.global_academic_semester_c = 'a3646000000dMXhAAM' --Spring 2019-20 (Semester)
        AND student_audit_status_c IN ('Current CT HS Student','Leave of Absence')))
        
--pull in students that were active at end of Summer 2019-20; CT Status (AT)
   OR(AY_Name = "AY 2019-20"
    AND term_c ='Summer'
    AND grade_c != '8th Grade'
    AND (CAT.global_academic_semester_c = 'a3646000000dMXiAAM' --Summer 2019-20 (Semester)
        AND student_audit_status_c IN ('Current CT HS Student')))
        
GROUP BY
    site_short, CAT.student_c
),

--Pull numerator: meaningful summer experience data from current and previous AY (hard-entry 2019-20)
gather_mse_data AS (
    SELECT 
        contact_id,
        m.site_short,
      
        --pull completed MSE last Summer
        MAX(CASE
            WHEN (AY_name = 'AY 2019-20'
            AND term_c = 'Summer')
            THEN 1
            ELSE 0
            END) AS mse_completed_prev_AY,
        --pull competitive MSE last Summer
        MAX(CASE 
            WHEN (competitive_c = True 
            AND AY_name = 'AY 2019-20'
            AND term_c = 'Summer')
            THEN 1
            ELSE 0
            END) AS mse_competitive_prev_AY,
        --pull completed internship last AY. Should this be limited to Summer only?
        MAX(CASE
            WHEN (type_c = 'Internship' 
            AND AY_name = 'AY 2019-20')
            THEN 1
            ELSE 0
            END) AS mse_internship_prev_AY,
            
FROM set_mse_reporting_group AS m
LEFT JOIN `data-warehouse-289815.salesforce.student_life_activity_c` AS sl 
    ON m.student_c = sl.student_c
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` AS c
    ON c.at_id = sl.semester_c 
        
WHERE sl.record_type_id = '01246000000ZNi8AAG' #Summer Experience
    AND AY_name IN ('AY 2020-21', 'AY 2019-20')
    AND term_c = 'Summer'
    AND experience_meaningful_c = True
    AND status_c = 'Approved'
GROUP BY 
    contact_id,
    site_short
),

--group attendance data by student first, aggregate at site level in prep_attendance_kpi
gather_attendance_data AS ( 
     SELECT 
        c.student_c, 
        CASE
            WHEN SUM(Attendance_Denominator_c) = 0 THEN NULL
            ELSE SUM(Attendance_Numerator_c) / SUM(Attendance_Denominator_c)
            END AS sl_attendance_rate
    FROM `data-warehouse-289815.salesforce_clean.class_template` AS c
        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT 
        ON CAT.global_academic_semester_c = c.global_academic_semester_c
    WHERE Department_c = "Student Life"
    AND Cancelled_c = FALSE
    AND CAT.AY_Name = 'AY 2020-21'
    GROUP BY c.student_c
),

prep_attendance_kpi AS (
    SELECT 
        site_short,
        CASE 
            WHEN sl_attendance_rate >= 0.8 THEN 1
            ELSE 0
            END AS sl_above_80_attendance,
    FROM gather_contact_data as gd
    LEFT JOIN gather_attendance_data AS attendance ON gd.contact_id = attendance.student_c
),

aggregate_attendance_kpi AS (
    SELECT 
        site_short,
        SUM(sl_above_80_attendance) AS sl_above_80_attendance
    FROM prep_attendance_kpi
    GROUP BY site_short
),

aggregate_dream_kpi AS (
    SELECT 
        site_short,
        SUM(dream_declared) as sl_dreams_declared
    FROM gather_contact_data
    GROUP BY site_short
),

aggregate_mse_kpis AS (
    SELECT 
        A.site_short,
        COUNT(DISTINCT student_c) AS mse_denom_prev_ay,
        SUM(mse_completed_prev_AY) AS sl_mse_completed_prev_AY,
        SUM(mse_competitive_prev_AY) AS sl_mse_competitive_prev_AY,
        SUM(mse_internship_prev_AY) AS sl_mse_internship_prev_AY,
    FROM gather_mse_data AS A
    LEFT JOIN set_mse_reporting_group AS B
    ON A.site_short = B.site_short
    GROUP BY site_short
)

SELECT 
    d.site_short,
    sl_dreams_declared,
    attendance_kpi.* EXCEPT (site_short),
    mse_kpi.* EXCEPT (site_short),
    mse_denom_prev_ay
    FROM aggregate_dream_kpi AS d 
        LEFT JOIN aggregate_attendance_kpi AS attendance_kpi ON d.site_short=attendance_kpi.site_short
        LEFT JOIN aggregate_mse_kpis AS mse_kpi ON d.site_short=mse_kpi.site_short
    /*GROUP BY
        site_short,
        sl_mse_completed_prev_AY,
        sl_mse_competitive_prev_AY,
        sl_mse_internship_prev_AY,
        mse_denom_prev_ay,
        sl_dreams_declared,
        sl_above_80_attendance
        */
        
