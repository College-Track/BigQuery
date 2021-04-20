/*CREATE OR REPLACE TABLE `data-studio-260217.kpi_dashboard.student_life` 
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
        Dream_Statement_filled_out_c,
        CASE
            WHEN Dream_Statement_filled_out_c = True THEN 1
            ELSE 0
            END AS dream_declared,
        summer_experiences_previous_summer_c
        
    FROM `data-warehouse-289815.salesforce_clean.contact_template` AS C
    WHERE college_track_status_c = '11A'

),

gather_mse_data AS ( #current AY
    SELECT 
        contact_id,
        site_short,
        type_c,
        semester_c,
        AY_name,
        CASE 
            WHEN competitive_c = True THEN 1
            ELSE 0
            END AS mse_competitive,
        CASE
            WHEN type_c = 'Internship' THEN 1
            ELSE 0
            END AS mse_internship
            
    FROM `data-warehouse-289815.salesforce.student_life_activity_c` AS sl
        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` AS c ON c.at_id = sl.semester_c
        
    WHERE sl.record_type_id = '01246000000ZNi8AAG' #Summer Experience
    AND AY_name = 'AY 2020-21'
    #AND term_c = 'Summer'
    AND experience_meaningful_c = True
    AND status_c = 'Approved'
),

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
        SUM(dream_declared) as total_dreams
    FROM gather_contact_data
    GROUP BY site_short
),

aggregate_mse_kpis AS (
    SELECT 
        site_short,
        SUM(mse_competitive) AS total_mse_competitive,
        SUM(mse_internship) AS total_mse_internship
    FROM gather_mse_data
    GROUP BY site_short
)

SELECT 
    d.site_short,
    attendance_kpi.* EXCEPT (site_short),
    mse_kpi.* EXCEPT (site_short)
    FROM aggregate_dream_kpi AS d 
        LEFT JOIN aggregate_attendance_kpi AS attendance_kpi ON d.site_short=attendance_kpi.site_short
        LEFT JOIN aggregate_mse_kpis AS mse_kpi ON d.site_short=mse_kpi.site_short
    GROUP BY
        site_short,
        total_mse_competitive,
        total_mse_internship,
        total_dreams,
        sl_above_80_attendance
