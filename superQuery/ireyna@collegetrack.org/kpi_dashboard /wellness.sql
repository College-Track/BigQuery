WITH 

--Gather contact and academic term data to join with COVI data
gather_at_data AS
(
SELECT 
    full_name_c,
    at_id,
    contact_id,
    AY_Name,
    site_short

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE record_type_id = '01246000000RNnSAAW' --HS student contact record type
    AND site != 'College Track Arlen'
    AND College_Track_Status_Name = 'Current CT HS Student'
),

--Pull Covi assessments completed within appropriate AYs (2019,20, 2020-21)
gather_covi_data AS (
SELECT 
    contact_name_c AS contact_id_covi,
    contact_id,
    academic_semester_c AS covi_at,
    id AS test_record_id,
    site_short,
    AY_Name,
    
    --Setting groundwork for indicator: students with a Covi score during 2020-21AY
    CASE 
        WHEN AY_Name = 'AY 2020-21'
        AND id IS NOT NULL 
        THEN 1
        ELSE 0
        END AS covi_assessment_completed_ay,
    
    --add Covi Domain scores to obtain total raw Covitality score. Use lowest score if student has 1+ Covi
    MIN(belief_in_self_raw_score_c + engaged_living_raw_score_c + belief_in_others_raw_score_c + emotional_competence_raw_score_c) AS min_covi_raw_score
    
FROM `data-warehouse-289815.salesforce_clean.test_clean` AS COVI
LEFT JOIN gather_at_data AS GAD
    ON GAD.at_id = COVI.academic_semester_c
    
WHERE COVI.record_type_id ='0121M000001cmuDQAQ' --Covitality test record type
    AND status_c = 'Completed'
    AND AY_Name IN ('AY 2019-20', 'AY 2020-21')
    
GROUP BY 
    contact_name_c,
    contact_id,
    academic_semester_c,
    id, --test record id
    site_short,
    AY_Name
    
ORDER BY
    site_short,
    contact_name_c,
    AY_Name
),

students_that_completed_covi AS (
SELECT 
    contact_id AS student_completed_covi_ay,
    site_short
  
FROM gather_covi_data
WHERE covi_assessment_completed_ay = 1
GROUP BY 
    contact_id,
    site_short
),
/*--Join COVI data completed 2020-21AY with contact_at data
join_term_data_with_covi AS (
SELECT 
    contact_id,
    student_site_c,
    test_record_id,
    
    --Indicator for students without a Covi score during 2020-21AY
    CASE 
        WHEN AY_Name = 'AY 2020-21'
        AND test_record_id IS NOT NULL 
        THEN 1
        ELSE 0
        END AS covi_assessment_completed_ay
   
FROM gather_at_data AS A
LEFT JOIN gather_covi_data AS C ON A.contact_id = C.contact_id_covi

GROUP BY 
    contact_id,
    student_site_c,
    raw_covi_score,
    AY_NAME,
    test_record_id
),


),
*/
--Using same logic from Site Director KPIs to calculate: % of students growing toward average or above social-emotional strengths
--This KPI is done over four CTEs. The majority of the logic is done in the second CTE.
calc_covi_growth AS (
SELECT
    site_short,
    contact_id_covi,
    min_covi_raw_score - lag(min_covi_raw_score) over (
      partition by contact_id_covi
      order by AY_Name
      ) AS covi_growth
FROM
    gather_covi_data
),

covi_growth_indicator AS (
SELECT
    site_short,
    contact_id_covi,
    
    --Indicator for students demonstrating growth in Covi taken between 2019-20 and 2020-21
    CASE
        WHEN covi_growth > 0 
        AND covi_growth IS NOT NULL
        THEN 1
        ELSE 0
        END AS covi_student_grew
        
FROM calc_covi_growth 
),

-- % of students growing toward average or above social-emotional strengths
-- This KPI is done over four CTEs (could probaly be made more efficient). The majority of the logic is done in the second CTE.

aggregate_covi_data AS (
SELECT
  A.site_short,
  COUNT(DISTINCT student_completed_covi_ay) AS wellness_covi_assessment_completed_ay,
  SUM(covi_student_grew) AS wellness_covi_student_grew,
  COUNT(contact_id_covi) AS wellness_covi_denominator
FROM covi_growth_indicator AS A
LEFT JOIN students_that_completed_covi AS B
    ON A.site_short = B.site_short
GROUP BY
  site_short
)

SELECT 
    wellness_covi_assessment_completed_ay
    wellness_covi_student_grew,
    wellness_covi_denominator
FROM aggregate_covi_data 
GROUP BY 
    site_short,
    wellness_covi_student_grew,
    wellness_covi_denominator


/*
gather_casenotes_data AS (
SELECT 
)
*/

    