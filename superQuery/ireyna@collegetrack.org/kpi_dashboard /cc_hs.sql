/*
CREATE OR REPLACE TABLE `data-studio-260217.kpi_dashboard.cc_hs` 
OPTIONS
    (
    description= "Aggregating College Completion - HS metrics for the Data Studio KPI dashboard"
    )
AS
*/
WITH gather_data_tenth_grade AS (
  SELECT
    Contact_Id,
    site_short,
    grade_c,
    FA_Req_Expected_Financial_Contribution_c,
    fa_req_efc_source_c,
    CASE
        WHEN (FA_Req_Expected_Financial_Contribution_c IS NOT NULL) AND (fa_req_efc_source_c = 'FAFSA4caster') THEN 1
        ELSE 0
    END AS hs_EFC_10th
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE  college_track_status_c = '11A'
    AND grade_c = '10th Grade'
),

gather_data_twelfth_grade AS (
    SELECT 
        contact_id,
        site_short,
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean` AS subq1
        WHERE College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Situational")  
        AND Contact_Id=subq1.student_c
        group by student_c
        ) AS applied_best_good_situational,
            
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq2
        WHERE admission_status_c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")
        AND Contact_Id=student_c
        group by student_c
        ) AS accepted_best_good_situational

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE  college_track_status_c = '11A'
    AND grade_c = '12th Grade'
),

agg_tenth_grade_metrics AS(
    SELECT
        SUM(hs_EFC_10th) AS cc_hs_EFC_tenth_grade,
        site_short
       
    FROM gather_data_tenth_grade 
    GROUP BY site_short
),

prep_twelfth_grade_metrics AS(
    SELECT  
        site_short,
        CASE 
            WHEN applied_best_good_situational IS NOT NULL THEN 1
            ELSE 0
        END AS cc_hs_applied_best_good_situational,
        
        CASE 
            WHEN accepted_best_good_situational IS NOT NULL THEN 1
            ELSE 0
        END AS cc_hs_accepted_best_good_situational
    
    FROM gather_data_twelfth_grade
    GROUP BY site_short,applied_best_good_situational,accepted_best_good_situational
),

agg_twelfth_grade_metrics AS (
    SELECT 
    SUM(cc_hs_applied_best_good_situational) AS cc_hs_applied_best_good_situational, #12th grade
    SUM(cc_hs_accepted_best_good_situational) AS cc_hs_accepted_best_good_situational, #12th grade
    site_short
    
    FROM prep_twelfth_grade_metrics
    GROUP BY site_short
)

  SELECT
    tenth_grade_data.*,
    twelfth_grade_data.* EXCEPT(site_short)
    
  FROM
     agg_tenth_grade_metrics as tenth_grade_data
     LEFT JOIN agg_twelfth_grade_metrics as twelfth_grade_data
     ON tenth_grade_data.site_short = twelfth_grade_data.site_short





