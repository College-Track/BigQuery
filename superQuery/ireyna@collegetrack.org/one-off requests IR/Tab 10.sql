WITH

join_term_data_with_covi AS (

SELECT 
    full_name_c,
    C.id AS test_record_id,
    test_date_c,
    contact_id,
    AY_Name,
    student_site_c

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS A
LEFT JOIN `data-warehouse-289815.salesforce_clean.test_clean` C ON A.at_id = C.academic_semester_c

)
SELECT 
    full_name_c,
    j.test_record_id,
    test_date_c AS first_covi_ay,
    --PERCENTILE_CONT(raw_covi_score, .5) OVER (PARTITION by student_site_c) AS first_raw_covi_score_median_ay, #median
    student_site_c
    
FROM join_term_data_with_covi AS j

WHERE j.test_date_c = (
    select MIN(j2.test_date_c) FROM join_term_data_with_covi j2 where j.contact_id = j2.contact_id)
    AND AY_Name IN ('AY 2020-21', 'AY 2019-20')
    AND contact_id = '0031M000033Eev9QAC'
    
GROUP BY 
    student_site_c,
    full_name_c,
    test_date_c,
    test_record_id