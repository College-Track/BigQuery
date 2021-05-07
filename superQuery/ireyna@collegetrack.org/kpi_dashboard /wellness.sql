WITH 

gather_at_data AS
(
SELECT 
    at_id,
    contact_id,
    AY_Name,
    site

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE record_type_id = '01246000000RNnSAAW' 
    AND site ='College Track Oakland' --!= 'College Track Arlen'
    AND College_Track_Status_Name = 'Current CT HS Student'
),

gather_covi_data AS (
SELECT 
    academic_semester_c,
    co_vitality_indicator_c,
    co_vitality_scorecard_color_c,
    belief_in_self_raw_score_c,
    belief_in_others_raw_score_c,
    emotional_competence_raw_score_c,
    engaged_living_raw_score_c,
    SUM(belief_in_self_raw_score_c + belief_in_others_raw_score_c + emotional_competence_raw_score_c + engaged_living_raw_score_c) AS raw_covi_score,
    version_c,
    status_c,
    --test_date_c, 
    co_vitality_test_completed_date_c, 
    id AS test_record_id, #test id
    student_site_c,
    record_type_id,
    CASE 
        WHEN id IS NOT NULL THEN 1
        ELSE 0
        END AS covi_assessment_completed_ay

FROM `data-warehouse-289815.salesforce_clean.test_clean` AS COVI
WHERE record_type_id ='0121M000001cmuDQAQ'
AND status_c = 'Completed'
GROUP BY 
    academic_semester_c,
    co_vitality_indicator_c,
    co_vitality_scorecard_color_c,
    belief_in_self_raw_score_c,
    belief_in_others_raw_score_c,
    emotional_competence_raw_score_c,
    engaged_living_raw_score_c,
    version_c,
    status_c,
    test_date_c, 
    id, #test id
    student_site_c,
    record_type_id
),

join_term_data_with_covi AS (
SELECT 
    --test_date_c,
    co_vitality_test_completed_date_c,
    student_site_c,
    raw_covi_score,
    contact_id,
    AY_NAME,
    covi_assessment_completed_ay,
    test_record_id
   
FROM gather_at_data AS A
LEFT JOIN gather_covi_data C ON A.at_id = C.academic_semester_c
WHERE AY_Name = 'AY 2019-20'
    AND status_c = 'Completed'
),

gather_students_with_more_than_1_covi AS (
SELECT 
    contact_id,
    SUM(covi_assessment_completed_ay) AS sum_of_covi_tests_taken_ay
    
FROM join_term_data_with_covi 
WHERE covi_assessment_completed_ay = 1
GROUP BY contact_id
),

gather_first_and_last_covi_ay AS (
SELECT 
    --test_date_c,
    co_vitality_test_completed_date_c,
    (SELECT MIN(co_vitality_test_completed_date_c)
     FROM join_term_data_with_covi j2 
     WHERE j.contact_id = j2.contact_id
    ) AS first_test,
    
    (SELECT MAX(co_vitality_test_completed_date_c)
     FROM join_term_data_with_covi j2 
     WHERE j.contact_id = j2.contact_id
    ) AS last_test,
    raw_covi_score, 
    PERCENTILE_CONT(raw_covi_score, .5) OVER (PARTITION by student_site_c) AS first_raw_covi_score_median_ay, #median
    student_site_c,
    j.contact_id,
    test_record_id
    
FROM gather_students_with_more_than_1_covi AS c
LEFT JOIN join_term_data_with_covi AS j ON c.contact_id = j.contact_id
--WHERE j.test_date_c = (select MIN(j2.test_date_c) FROM join_term_data_with_covi j2 where j.contact_id = j2.contact_id)
WHERE AY_Name = 'AY 2019-20'
    AND sum_of_covi_tests_taken_ay > 1
GROUP BY
    student_site_c,
    raw_covi_score, 
    j.contact_id,
    test_record_id,
    --test_date_c
    co_vitality_test_completed_date_c
)

--gather_first_covi_score_data_ay AS (
SELECT 
    contact_id,
    raw_covi_score,
    first_raw_covi_score_median_ay,
    first_test,
    test_date_c
FROM gather_first_and_last_covi_ay AS A
WHERE co_vitality_test_completed_date_c = first_test
    AND raw_covi_score = (select MIN(A2.raw_covi_score) FROM gather_first_and_last_covi_ay AS A2 where A.contact_id = A2.contact_id) 
    --pull lowest CoVi score if student has more than 1 test on the same date
