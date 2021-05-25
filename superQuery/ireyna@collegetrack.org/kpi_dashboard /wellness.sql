WITH 

--Gather contact and academic term data to join with COVI data
gather_at_data AS
(
SELECT 
    full_name_c,
    at_id,
    at_name,
    contact_id,
    AY_Name,
    site

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE record_type_id = '01246000000RNnSAAW' --HS student contact record type
    AND site != 'College Track Arlen'
    AND College_Track_Status_Name = 'Current CT HS Student'
   -- AND AY_Name = 'AY 2020-21' --To pull in Covi test records within this given AY 
),

--Pull Covi assessments completed within the 2020-21 AY
gather_covi_data AS (
SELECT 
    contact_name_c AS contact_id_covi,
    academic_semester_c AS covi_at,
    co_vitality_scorecard_color_c,
    
    --add Covi Domain scores to obtain total raw Covitality score
    SUM(belief_in_self_raw_score_c + belief_in_others_raw_score_c + emotional_competence_raw_score_c + engaged_living_raw_score_c) AS raw_covi_score,
    
    id AS test_record_id,
    student_site_c,
    record_type_id

FROM `data-warehouse-289815.salesforce_clean.test_clean` AS COVI
LEFT JOIN gather_at_data AS GAD
    ON GAD.at_id = COVI.academic_semester_c
    
WHERE COVI.record_type_id ='0121M000001cmuDQAQ' --Covitality test record type
    AND status_c = 'Completed'
    AND AY_Name = 'AY 2020-21'
    
GROUP BY 
    contact_name_c,
    academic_semester_c,
    co_vitality_scorecard_color_c,
    belief_in_self_raw_score_c,
    belief_in_others_raw_score_c,
    emotional_competence_raw_score_c,
    engaged_living_raw_score_c,
    id, --test record id
    student_site_c,
    record_type_id
    
),

--Join COVI data completed 2020-21AY with contact_at data
join_term_data_with_covi AS (
SELECT 
    full_name_c,
    contact_id,
    covi_at, 
    student_site_c,
    raw_covi_score,
    AY_NAME,
    test_record_id,
    
    --Indicator for students without a Covi score during 2020-21AY
    CASE 
        WHEN test_record_id IS NOT NULL THEN 1
        ELSE 0
        END AS covi_assessment_completed_ay
   
FROM gather_at_data AS A
LEFT JOIN gather_covi_data AS C ON A.contact_id = C.contact_id_covi

GROUP BY 
    full_name_c,
    contact_id,
    co_vitality_test_completed_date_c,
    covi_at,
    student_site_c,
    raw_covi_score,
    AY_NAME,
    test_record_id
)


--gather_students_with_more_than_1_covi AS (
SELECT 
    contact_id,
    --SUM(covi_assessment_completed_ay) AS sum_of_covi_tests_taken_ay --does sudent have more than 1 covi assessment?
    
FROM join_term_data_with_covi 
WHERE covi_assessment_completed_ay = 0
GROUP BY contact_id