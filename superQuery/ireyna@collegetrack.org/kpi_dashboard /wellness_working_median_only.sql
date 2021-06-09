--KPI: Increase in median CoVitality raw score of students served by Wellness over the course of their high school career
--12th grade only

with gather_at_data AS --in wellness query
(
SELECT 
    full_name_c,
    at_id,
    contact_id,
    AY_Name,
    site_short

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE College_Track_Status_Name = 'Current CT HS Student'
    AND 
        (grade_c IN ('9th Grade','10th Grade','11th Grade')
        OR 
        (grade_c = "12th Grade" OR (grade_c='Year 1' AND indicator_years_since_hs_graduation_c = 0)))
),
--Pull Covi assessments completed within appropriate AYs (2019-20, 2020-21) --in wellness query
gather_covi_data AS (
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
    MAX(CASE 
        WHEN test_record_id IS NOT NULL 
        THEN 1
        ELSE 0
        END) AS covi_assessment_completed_ay
FROM gather_covi_data
WHERE AY_Name = 'AY 2020-21'
GROUP BY
    contact_id,
    site_short,
    test_record_id
),

--Isolate students that completed a Covitality assessment in 2020-21AY
students_that_completed_covi AS (
SELECT 
    COUNT(DISTINCT contact_id) AS covi_assessment_completed_ay, --in wellness query
    site_short
  
FROM completing_covi_data 
WHERE covi_assessment_completed_ay = 1
GROUP BY 
    site_short
)
--Following queries are laying groundwork to take median of all students' first test, and compare median score of all students' last test
--Look at 12th grade students with more than 1 Covi assessement

--Identify students with more than 1 Covitality assessment
--gather_students_with_more_than_1_covi AS (
SELECT 
    
    SUM(covi_assessment_completed_ay) AS sum_of_covi_tests_taken_ay, --does sudent have more than 1 covi assessment?
    covi.site_short
FROM completing_covi_data  AS covi
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` AS contact on covi.contact_id=contact.contact_id
WHERE covi_assessment_completed_ay = 1
AND grade_c = "12th Grade"
GROUP BY  site_short