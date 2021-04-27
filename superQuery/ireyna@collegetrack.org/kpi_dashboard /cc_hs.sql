
CREATE OR REPLACE TABLE `data-studio-260217.kpi_dashboard.cc_hs` 
OPTIONS
    (
    description= "Aggregating College Completion - HS metrics for the Data Studio KPI dashboard"
    )
AS

WITH gather_data AS ( #active CT students; 10th grade EFC; 11th grade college aspirations
    SELECT
        contact_id,
        site_short,
        
         --10th Grade EFC num and demom
        CASE
            WHEN (c.grade_c = "10th Grade" 
            AND FA_Req_Expected_Financial_Contribution_c IS NOT NULL 
            AND fa_req_efc_source_c = 'FAFSA4caster') THEN 1
            ELSE 0
            END AS hs_EFC_10th_num,
            
        CASE
            WHEN (c.grade_c = "10th Grade" 
            AND college_track_status_c = '11A') THEN 1
            ELSE 0
            END AS hs_EFC_10th_denom,
            
     --11th Grade Aspirations num and demom
        CASE 
            WHEN (c.grade_c = '11th Grade'
            AND college_track_status_c = '11A'
            AND a.id IS NOT NULL) THEN 1
            ELSE 0
            END AS aspirations_any_num,
        
        CASE
            WHEN (c.grade_c = '11th Grade' 
            AND fit_type_current_c IN ("Best Fit","Good Fit","Local Affordable")) THEN 1
            ELSE 0
            END AS aspirations_affordable_num,
            
        CASE 
            WHEN (c.grade_c = '11th Grade'
            AND college_track_status_c = '11A') THEN 1
            ELSE 0
            END AS aspirations_denom
            
    FROM `data-warehouse-289815.salesforce_clean.contact_template` AS c
    LEFT JOIN`data-warehouse-289815.salesforce.college_aspiration_c` a ON c.contact_id=a.student_c
    WHERE college_track_status_c = '11A'
),

gather_attendance_data AS ( #for 12th grade KPI: 80% CC attendance
    SELECT 
        c.student_c, 
        CASE
            WHEN SUM(Attendance_Denominator_c) = 0 THEN NULL
            ELSE SUM(Attendance_Numerator_c) / SUM(Attendance_Denominator_c)
            END AS attendance_rate
    FROM `data-warehouse-289815.salesforce_clean.class_template` AS c
        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT 
        ON CAT.global_academic_semester_c = c.global_academic_semester_c
    WHERE Department_c = "College Completion"
    AND Cancelled_c = FALSE
    AND CAT.AY_Name = 'AY 2020-21'
    GROUP BY c.student_c
),
        
gather_data_twelfth_grade AS (
    SELECT 
        contact_id,
        attendance_rate,
        
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq1
        WHERE admission_status_c = "Accepted" AND College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Local Affordable")
        AND Contact_Id=student_c
        group by student_c
        ) AS applied_accepted_affordable,
        
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq2
        WHERE admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred") AND fit_type_enrolled_c IN ("Best Fit","Good Fit","Local Affordable","Situational")
        AND Contact_Id=student_c
        group by student_c
        ) AS accepted_enrolled_affordable,
        
        site_short,
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean` AS subq3
        WHERE College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Situational")  
        AND Contact_Id=student_c
        group by student_c
        ) AS applied_best_good_situational,
            
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq4
        WHERE admission_status_c = "Accepted" AND College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Situational")
        AND Contact_Id=student_c
        group by student_c
        ) AS applied_accepted_best_good_situational,
        
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq5
        WHERE admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred") AND fit_type_enrolled_c IN ("Best Fit","Good Fit","Situational")
        AND Contact_Id=student_c
        group by student_c
        ) AS accepted_enrolled_best_good_situational,
        
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
        LEFT JOIN gather_attendance_data ON contact_id=student_c
    WHERE  college_track_status_c = '11A'
    AND grade_c = '12th Grade'
),

gather_eleventh_grade_metrics AS ( #11th grade College Aspirations KPI
 SELECT
    site_short,
    CASE 
        WHEN (SUM(g.aspirations_any_num) >= 6 AND SUM(g.aspirations_affordable_num) >= 3) THEN 1
        ELSE 0
        END AS cc_hs_aspirations
    FROM gather_data as g
    GROUP BY contact_id,site_short
),

gather_twelfth_grade_metrics AS(
    SELECT  
        site_short,
        CASE 
            WHEN attendance_rate >= 0.8 THEN 1
            ELSE 0
            END AS cc_hs_above_80_cc_attendance,
        CASE 
            WHEN accepted_enrolled_affordable IS NOT NULL THEN 1
            WHEN applied_accepted_affordable IS NOT NULL THEN 1
            ELSE 0
            END AS cc_hs_accepted_affordable,
        CASE 
            WHEN applied_best_good_situational IS NOT NULL THEN 1
            ELSE 0
            END AS cc_hs_applied_best_good_situational,
        CASE 
            WHEN accepted_enrolled_best_good_situational IS NOT NULL THEN 1
            WHEN applied_accepted_best_good_situational IS NOT NULL THEN 1
            ELSE 0
            END AS cc_hs_accepted_best_good_situational
    FROM gather_data_twelfth_grade
),


#prep KPIs for aggregation

prep_tenth_grade_metrics AS ( #10th Grade EFC KPI
    SELECT 
        site_short,
        SUM(hs_EFC_10th_num) AS cc_hs_EFC_tenth_grade
    FROM gather_data  
    GROUP BY site_short
),

prep_eleventh_grade_metrics AS ( #11th grade College Aspirations KPI
    SELECT 
        site_short,
        SUM(cc_hs_aspirations) AS cc_hs_aspirations
    FROM gather_eleventh_grade_metrics
    GROUP BY site_short
),

prep_twelfth_grade_metrics AS (
    SELECT 
        site_short,
        SUM(cc_hs_above_80_cc_attendance) AS cc_hs_above_80_cc_attendance,
        SUM(cc_hs_accepted_affordable) AS cc_hs_accepted_affordable,
        SUM(cc_hs_applied_best_good_situational) AS cc_hs_applied_best_good_situational,
        SUM(cc_hs_accepted_best_good_situational) AS cc_hs_accepted_best_good_situational 
    FROM gather_twelfth_grade_metrics
    GROUP BY site_short
)

#final kpi join
SELECT 
    gd.site_short,
    kpi_10th.* EXCEPT(site_short),
    kpi_11th.* EXCEPT(site_short),
    kpi_12th.* EXCEPT(site_short)
    FROM gather_data as gd
        LEFT JOIN prep_tenth_grade_metrics AS kpi_10th ON gd.site_short = kpi_10th.site_short
        LEFT JOIN prep_eleventh_grade_metrics AS kpi_11th ON gd.site_short = kpi_11th.site_short
        LEFT JOIN prep_twelfth_grade_metrics AS kpi_12th ON gd.site_short = kpi_12th.site_short
GROUP BY
    site_short, 
    cc_hs_EFC_tenth_grade,
    cc_hs_aspirations,
    cc_hs_above_80_cc_attendance,
    cc_hs_accepted_affordable,
    cc_hs_applied_best_good_situational,
    cc_hs_accepted_best_good_situational 




