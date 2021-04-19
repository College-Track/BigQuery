WITH gather_data AS (
    SELECT
        contact_id,
        site_short
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c = '11A'
),

gather_data_tenth_grade AS (
  SELECT
    site_short,
    contact_id,
    
    CASE
        WHEN (FA_Req_Expected_Financial_Contribution_c IS NOT NULL) AND (fa_req_efc_source_c = 'FAFSA4caster') THEN 1
        ELSE 0
        END AS hs_EFC_10th
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE  college_track_status_c = '11A'
    AND grade_c = '10th Grade'
    
),

gather_data_eleventh_grade AS (
    SELECT 
        contact_id,
        site_short,
        
        CASE 
            WHEN a.id IS NOT NULL THEN 1
            ELSE 0
            END AS student_has_aspirations,
        
        CASE
            WHEN fit_type_current_c IN ("Best Fit","Good Fit","Local Affordable") THEN 1
            ELSE 0
            END AS aspirations_affordable
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template` c 
        LEFT JOIN`data-warehouse-289815.salesforce.college_aspiration_c` a ON c.contact_id=a.student_c
    
    WHERE college_track_status_c = '11A'
    AND c.grade_c = '11th Grade'
    
),



gather_attendance_data AS (
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

#Prepping metrics
/*prep_tenth_grade_metrics AS(
    SELECT
        SUM(hs_EFC_10th) AS cc_hs_EFC_tenth_grade,
        site_short AS site
       
    FROM gather_data_tenth_grade 
    GROUP BY site_short
),*/

/*prep_eleventh_grade_metrics AS (
    SELECT 
        site_short,
        SUM(cc_hs_aspirations) AS cc_hs_aspirations
    FROM prep_aspiration_kpi
    GROUP BY site_short
),*/
prep_eleventh_grade_metrics AS (
 SELECT
    site_short,
    contact_id,
    CASE 
        WHEN student_has_aspirations >= 6 AND aspirations_affordable >= 3 THEN 1
        ELSE 0
        END AS cc_hs_aspirations
        
    FROM gather_data_eleventh_grade 
       
),
prep_twelfth_grade_metrics AS(
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
)

  SELECT
    gd.site_short, 
    SUM(hs_EFC_10th) AS cc_hs_EFC_tenth_grade, #10th grade
    SUM(cc_hs_aspirations) AS cc_hs_aspirations, #11th grade
    SUM(cc_hs_above_80_cc_attendance) AS cc_hs_above_80_cc_attendance,#12th grade 
    SUM(cc_hs_accepted_affordable) AS cc_hs_accepted_affordable,
    SUM(cc_hs_applied_best_good_situational) AS cc_hs_applied_best_good_situational, #12th grade
    SUM(cc_hs_accepted_best_good_situational) AS cc_hs_accepted_best_good_situational #12th grade
    
  FROM
        gather_data AS gd
        
        LEFT JOIN gather_data_tenth_grade AS tenth_grade_data
            ON GD.site_short = tenth_grade_data.site_short
     
        LEFT JOIN prep_eleventh_grade_metrics AS eleventh_grade_data
            ON GD.site_short = eleventh_grade_data.site_short
        
        LEFT JOIN prep_twelfth_grade_metrics AS twelfth_grade_data
            ON GD.site_short = twelfth_grade_data.site_short
    
GROUP BY gd.site_short
