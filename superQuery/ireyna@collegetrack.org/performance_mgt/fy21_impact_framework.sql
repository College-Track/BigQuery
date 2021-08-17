
CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.fy21_impact_framework`
OPTIONS
    (
    description= "Table of FY21 outcomes for Impact Framework data entry"
    )
AS (


WITH gather_data AS (
    SELECT
        AY.Contact_Id,
        C.site_short,
        CASE
            WHEN C.site_short = 'East Palo Alto' THEN 1
            WHEN C.site_short = 'Oakland' THEN 2
            WHEN C.site_short = 'San Francisco' THEN 3
            WHEN C.site_short = 'New Orleans' THEN 4
            WHEN C.site_short = 'Aurora' THEN 5
            WHEN C.site_short = 'Boyle Heights' THEN 6
            WHEN C.site_short = 'Sacramento' THEN 7
            WHEN C.site_short = 'Watts' THEN 8
            WHEN C.site_short = 'Denver' THEN 9
            WHEN C.site_short = 'The Durant Center' THEN 10
            WHEN C.site_short = 'Ward 8' THEN 11
            WHEN C.site_short = 'Crenshaw' THEN 12
            END AS if_site_sort,
        CASE
            WHEN AY.AY_student_served = 'High School' THEN 1
            ELSE 0
            END AS high_school_student_count,
        CASE
            WHEN AY.AY_student_served = 'High School' AND AY_Grade = '9th Grade' THEN 1
            ELSE 0
            END AS ninth_grade_count,
        CASE
            WHEN AY.AY_student_served = 'High School' AND AY_Grade = '9th Grade' AND
                 C.contact_official_test_prep_withdrawal IS NULL THEN 1
            ELSE 0
            END AS ninth_grade_count_valid_test,
        CASE
            WHEN AY.AY_student_served = 'High School' AND AY_Grade = '10th Grade' THEN 1
            ELSE 0
            END AS tenth_grade_count,
        CASE
            WHEN AY.AY_student_served = 'High School' AND AY_Grade = '10th Grade' AND
                 C.contact_official_test_prep_withdrawal IS NULL THEN 1
            ELSE 0
            END AS tenth_grade_count_valid_test,
        CASE
            WHEN AY.AY_student_served = 'High School' AND AY_Grade = '12th Grade' THEN 1
            ELSE 0
            END AS twelfth_grade_count,
        CASE
            WHEN AY.AY_student_served = 'High School' AND AY_Grade = '12th Grade' AND
                 C.contact_official_test_prep_withdrawal IS NULL THEN 1
            ELSE 0
            END AS twelfth_grade_count_valid_test,
        CASE
            WHEN C.indicator_completed_ct_hs_program_c = TRUE AND AY_Grade != '12th Grade' THEN 1
            ELSE 0
            END AS ps_student_count,
        CASE
            WHEN AY.dream_statement_filled_out_c = TRUE AND AY_Grade = '9th Grade' THEN 1
            ELSE 0
            END AS dream_filled_out,

        CASE
            WHEN C.community_service_hours_c >= 100 AND AY_Grade = '12th Grade' THEN 1
            ELSE 0
            END AS community_service_met,
        CASE
            WHEN AY.indicator_first_generation_c = 'Yes' AND AY_Grade = '9th Grade' THEN 1
            ELSE 0
            END AS first_gen,
        CASE
            WHEN AY.indicator_low_income_c = 'Yes' AND AY_Grade = '9th Grade' THEN 1
            ELSE 0
            END AS low_income,
        CASE
            WHEN AY.readiness_math_official_c = TRUE AND AY_Grade = '12th Grade' AND
                 C.contact_official_test_prep_withdrawal IS NULL THEN 1
            ELSE
                0
            END
            read_math_official,
            
        --added by IR    
        CASE 
            WHEN C.readiness_composite_off_c = '1. Ready' AND AY_Grade = '12th Grade' AND
                 C.contact_official_test_prep_withdrawal IS NULL THEN 1
            ELSE 
                0
            END 
            read_composite_official,
        
        
        CASE
            WHEN AY.readiness_10_th_composite_c = TRUE AND AY_Grade = '10th Grade' AND
                 C.contact_official_test_prep_withdrawal IS NULL THEN 1
            ELSE
                0
            END
            readiness_10th_composite,
        CASE
            WHEN AY.readiness_9_th_math_c = TRUE AND AY_Grade = '9th Grade' AND
                 C.contact_official_test_prep_withdrawal IS NULL THEN 1
            ELSE
                0
            END
            readiness_9th_math,
        CASE
            WHEN AY.AY_Cumulative_GPA >= 3.0 AND AY_student_served = 'High School' THEN 1
            ELSE
                0
            END
            above_3_gpa,

        CASE
            WHEN AY.above_80_attendance_ay = 'True' AND AY_student_served = 'High School' THEN 1
            ELSE
                0
            END
            above_80_attendance,
        CASE
            WHEN C.fa_req_fafsa_c = 'Submitted' AND AY_Grade = '12th Grade' AND
                 C.citizen_c_c IN ('US Citizen', 'Permanent Resident', 'Other', 'U-Visa') THEN 1
            ELSE
                0
            END
            AS fafas_submitted,
        AY.four_year_retention_denominator,
        AY.four_year_retention_numerator


    FROM `data-studio-260217.ddt.ay_2020_21_summary_table` AY
         LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON AY.Contact_Id = C.Contact_Id
    WHERE AY.AY_student_served IN ('High School', 'Post Secondary')
)

SELECT
    site_short,
    if_site_sort,
    SUM(high_school_student_count) AS high_school_student_count,
    SUM(ninth_grade_count) AS ninth_grade_count,
    SUM(tenth_grade_count) AS tenth_grade_count,
    SUM(twelfth_grade_count) AS twelfth_grade_count,
    SUM(ninth_grade_count_valid_test) AS ninth_grade_count_valid_test,
    SUM(tenth_grade_count_valid_test) AS tenth_grade_count_valid_test,
    SUM(twelfth_grade_count_valid_test) AS twelfth_grade_count_valid_test,
    SUM(ps_student_count) AS ps_student_count,
    SUM(dream_filled_out) AS dream_filled_out,
    SUM(community_service_met) AS community_service_met,
    SUM(first_gen) AS first_gen,
    SUM(low_income) AS low_income,
    SUM(read_math_official) AS read_math_official,
    SUM(read_composite_official) AS read_composite_official,
    SUM(readiness_10th_composite) AS readiness_10th_composite,
    SUM(readiness_9th_math) AS readiness_9th_math,
    SUM(above_3_gpa) AS above_3_gpa,
    SUM(four_year_retention_numerator) AS four_year_retention_numerator,
    SUM(four_year_retention_denominator) AS four_year_retention_denominator
FROM gather_data
GROUP BY site_short, if_site_sort
ORDER BY if_site_sort

-- dreams
-- service hours
-- first gen
-- low income
-- math readiness seniors
-- gpa above 3.0
-- composite readiness seniors
-- four year retention
-- above 80% attendance
-- 10th grade diagnostic compiste readiness
-- 9th grade diagnositcs math readiness
-- hs capacity enrolled
-- fafsa completion
)