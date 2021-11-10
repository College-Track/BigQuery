CREATE OR REPLACE TABLE `org-scorecard-286421.aggregate_data.social_emotional_growth_fy21`
OPTIONS
    (
    description="This table stores the fy21 numerator and denominator for social emotional growth outcome, org scorecard" 
    )
    AS
    
WITH 
gather_covi_data AS (
    SELECT
        contact_name_c,
        site_short,
        region_short,
        AY_Name,
        MIN(belief_in_self_raw_score_c + engaged_living_raw_score_c + belief_in_others_raw_score_c + emotional_competence_raw_score_c) AS covi_raw_score
    FROM `data-warehouse-289815.salesforce_clean.test_clean` T
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
        ON CAT.AT_Id = T.academic_semester_c
    WHERE
        T.record_type_id = '0121M000001cmuDQAQ'
        AND AY_Name IN ('AY 2019-20', 'AY 2020-21')
        AND AY_2020_21_student_served_c = 'High School Student'
    GROUP BY
        site_short,
        region_short,
        contact_name_c,
        AY_Name
    ORDER BY
        site_short,
        region_short,
        contact_name_c,
        AY_Name
),

-- CONT'D: Org Scoreard COVI % of students growing toward average or above social-emotional strengths
calc_covi_growth AS (
    SELECT
        site_short,
        region_short,
        contact_name_c,
        covi_raw_score - LAG(covi_raw_score) OVER (PARTITION BY contact_name_c ORDER BY AY_Name) AS covi_growth --Returns the value of the value_expression on a preceding row.
    FROM gather_covi_data

),

-- CONT'D: Org Scoreard COVI % of students growing toward average or above social-emotional strengths
determine_covi_indicators AS (
    SELECT
        site_short,
        region_short,
        contact_name_c,
        SUM(CASE
            WHEN covi_growth > 0
            THEN 1
            ELSE 0
        END) AS covi_student_grew

    FROM calc_covi_growth
    WHERE
            covi_growth IS NOT NULL

    GROUP BY
        site_short,
        region_short,
        contact_name_c
)

SELECT
    site_short,
    region_short,
    SUM(covi_student_grew) AS social_emotional_growth_numerator,
    COUNT(contact_name_c) AS social_emotional_growth_denominator
FROM determine_covi_indicators
GROUP BY site_short, region_short