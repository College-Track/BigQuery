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
    AND site_short != 'College Track Arlen'
    AND AY_Name = 'AY 2020-21'
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
    test_date_c, 
    id AS test_record_id, #test id
    student_site_c,
    record_type_id,
    CASE 
        WHEN id IS NOT NULL THEN 1
        ELSE 0
        END AS covi_assessment_ay

FROM `data-warehouse-289815.salesforce_clean.test_clean` COVI
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
    test_record_id,
    test_date_c,
    contact_id,
    AY_Name,
    student_site_c,
    raw_covi_score

FROM gather_at_data AS A
LEFT JOIN gather_covi_data C ON A.at_id = C.academic_semester_c
WHERE AY_Name IN ('AY 2020-21', 'AY 2019-20')
AND status_c = 'Completed'
),

gather_first_covi_ay AS (
SELECT 
    test_date_c AS first_covi_ay,
    raw_covi_score AS first_score,
    contact_id,
    PERCENTILE_CONT(raw_covi_score, .5) OVER (PARTITION by student_site_c) AS first_raw_covi_score_median_ay, #median
    student_site_c,
    test_record_id
    
FROM join_term_data_with_covi AS j
WHERE j.test_date_c = (select MIN(j2.test_date_c) FROM join_term_data_with_covi j2 where j.contact_id = j2.contact_id)
    AND contact_id = '0034600001TR5uoAAD'

),

gather_last_covi_ay AS (
SELECT 
    test_date_c AS last_covi_ay,
    contact_id,
    raw_covi_score AS last_score,
    PERCENTILE_CONT(raw_covi_score, .5) OVER (PARTITION by student_site_c) AS last_raw_covi_score_median_ay,#median
    student_site_c

FROM join_term_data_with_covi AS j
WHERE j.test_date_c = (select MAX(j2.test_date_c) FROM join_term_data_with_covi j2 where j.contact_id = j2.contact_id)

    AND contact_id = '0034600001TR5uoAAD'

    
)
/*
gather_casenotes_data AS (
SELECT 
)
*/

--prep_kpi AS (
SELECT 
    A.contact_id,
    --covi_assessment_ay,
    CF.student_site_c,
    last_covi_ay,
    first_covi_ay,
    CF.first_raw_covi_score_median_ay,
    CL.last_raw_covi_score_median_ay,
    first_score,
    last_score,
    CASE 
        WHEN last_raw_covi_score_median_ay > first_raw_covi_score_median_ay THEN 1
        ELSE 0
    END AS wellness_covi_median_growth
 
FROM gather_at_data as A     
--LEFT JOIN gather_covi_data as C ON C.academic_semester_c = A.at_id
LEFT JOIN gather_first_covi_ay AS CF ON CF.contact_id = A.contact_id
LEFT JOIN gather_last_covi_ay AS CL ON CL.contact_id = A.contact_id
GROUP BY 
    contact_id, 
    student_site_c,
    --covi_assessment_ay,
    first_score,
    last_score,
    first_raw_covi_score_median_ay,
    last_raw_covi_score_median_ay,
    last_covi_ay,
    first_covi_ay