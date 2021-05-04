WITH gather_covi_data AS (
SELECT 
academic_semester_c,
co_vitality_indicator_c,
co_vitality_scorecard_color_c,
version_c,
status_c,
test_date_c, 
id AS test_record_id, #test id
student_site_c

FROM `data-warehouse-289815.salesforce_clean.test_clean` COVI

WHERE record_type_id ='0121M000001cmuDQAQ'
AND status_c = 'Completed'
),

gather_at_data AS
(
SELECT 
at_id,
contact_id,
AY_Name,

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE record_type_id = '01246000000RNnSAAW' 
AND site_short != 'College Track Arlen'
AND AY_Name = 'AY 2020-21'

),

--prep_kpi AS (
SELECT 
    CASE 
        WHEN test_record_id IS NOT NULL THEN 1
        ELSE 0
    END AS covi_assessment_ay,
    student_site_c,
    contact_id
    
FROM gather_covi_data as C
LEFT JOIN gather_at_data as A ON C.academic_semester_c=A.at_id
)