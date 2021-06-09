--KPI: Increase in median CoVitality raw score of students served by Wellness over the course of their high school career
--12th grade only


--Pull Covi assessments completed within appropriate AYs (2019-20, 2020-21) --in wellness query
WITH gather_covi_data AS (
SELECT 
    contact_name_c AS contact_id_covi,
    contact_id, --from contact_at
    id AS test_record_id,
    site_short,
    AY_Name,
    co_vitality_scorecard_color_c,
    belief_in_self_raw_score_c, 
    engaged_living_raw_score_c,
    belief_in_others_raw_score_c,
    emotional_competence_raw_score_c,
    
FROM `data-warehouse-289815.salesforce_clean.test_clean` AS COVI
LEFT JOIN gather_at_data AS GAD
    ON GAD.at_id = COVI.academic_semester_c
    
WHERE COVI.record_type_id ='0121M000001cmuDQAQ' --Covitality test record type --in wellness query
    AND status_c = 'Completed'
    AND AY_Name = 'AY 2020-21'
),

--Setting groundwork for KPI indicator: % of students who have taken the the CoVi assessment each academic year (2020-21AY)
--Gathered in 2 CTEs
completing_covi_data AS ( --in wellness query
SELECT 
    site_short,
    contact_id,
    CASE 
        WHEN test_record_id IS NOT NULL 
        THEN 1
        ELSE 0
        END AS covi_assessment_completed_ay
FROM gather_covi_data
WHERE AY_Name = 'AY 2020-21'
GROUP BY
    contact_id,
    site_short,
    test_record_id
)

--Isolate students that completed a Covitality assessment in 2020-21AY
--students_that_completed_covi AS (
SELECT 
    COUNT(DISTINCT contact_id) AS covi_assessment_completed_ay, --in wellness query
    site_short
  
FROM completing_covi_data
WHERE covi_assessment_completed_ay = 1
GROUP BY 
    site_short