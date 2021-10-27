--Using FY21_eoy_combined_metrics table
/*
    

    Strategy Team representing a spectrum of identities above average nonprofit benchmarks*
    Annual Fundraising target (100%)
    Staff with full-time tenure of 3+ years in organization (35%)
  
    Staff engagement score above average nonprofit benchmark (Y)
*/

WITH 
fy20_measures AS (
    SELECT 
        CASE 
            WHEN Site__Account_Name = 'College Track East Palo Alto' THEN 'East Palo Alto'
            WHEN Site__Account_Name = 'College Track Oakland' THEN 'Oakland'
            WHEN Site__Account_Name = 'College Track San Francisco' THEN 'San Francisco'
            WHEN Site__Account_Name = 'College Track New Orleans' THEN 'New Orleans'
            WHEN Site__Account_Name = 'College Track Aurora' THEN 'Aurora'
            WHEN Site__Account_Name = 'College Track Boyle Heights' THEN 'Boyle Heights'
            WHEN Site__Account_Name = 'College Track Sacramento' THEN 'Sacramento'
            WHEN Site__Account_Name = 'College Track Watts' THEN 'Watts'
            WHEN Site__Account_Name = 'College Track Denver' THEN 'Denver'
            WHEN Site__Account_Name = 'College Track at The Durant Center' THEN 'The Durant Center'
            WHEN Site__Account_Name = 'College Track Ward 8' THEN 'Ward 8'
            WHEN Site__Account_Name = 'College Track Crenshaw' THEN 'Crenshaw'
        END AS site_short,
        
        CASE 
            WHEN Site__Account_Name = 'College Track East Palo Alto' THEN 'EPA'
            WHEN Site__Account_Name = 'College Track Oakland' THEN 'OAK'
            WHEN Site__Account_Name = 'College Track San Francisco' THEN 'SF'
            WHEN Site__Account_Name = 'College Track New Orleans' THEN 'NOLA'
            WHEN Site__Account_Name = 'College Track Aurora' THEN 'AUR'
            WHEN Site__Account_Name = 'College Track Boyle Heights' THEN 'BH'
            WHEN Site__Account_Name = 'College Track Sacramento' THEN 'SAC'
            WHEN Site__Account_Name = 'College Track Watts' THEN 'WATTS'
            WHEN Site__Account_Name = 'College Track Denver' THEN 'DEN'
            WHEN Site__Account_Name = 'College Track at The Durant Center' THEN 'PGC'
            WHEN Site__Account_Name = 'College Track Ward 8' THEN 'DC8'
            WHEN Site__Account_Name = 'College Track Crenshaw' THEN 'CREN'
        END AS site_abrev,
        
        CASE 
            WHEN Region__Account_Name = 'College Track Northern California Region' THEN 'Northern California'
            WHEN Region__Account_Name = 'College Track Los Angeles Region' THEN 'Los Angeles'
            WHEN Region__Account_Name = 'College Track Colorado' THEN 'Colorado'
            WHEN Region__Account_Name = 'College Track DC' THEN 'DC'
        END AS region_short,
        
        CASE 
            WHEN Region__Account_Name = 'College Track Northern California Region' THEN 'NORCAL'
            WHEN Region__Account_Name = 'College Track Los Angeles Region' THEN 'LA'
            WHEN Region__Account_Name = 'College Track Colorado' THEN 'CO'
            WHEN Region__Account_Name = 'College Track DC' THEN 'DC'
        END AS region_short,
        
    FROM `org-scorecard-286421.aggregate_data.objective_1_site` AS obj1
    LEFT JOIN `org-scorecard-286421.aggregate_data.objective_1_region` obj2
        ON obj1.Region__Account_Name = obj2.Region
    FULL OUTER JOIN  `org-scorecard-286421.aggregate_data.financial_sustainability_fy20` AS obj7
        ON obj1.Region__Account_Name = obj7.Account AND obj1.Site__Account_Name = obj2.Region
),      

fy21_measures AS (
    SELECT
        if_site_sort,
        site_short,
        region_short,
    --reporting group denominators
        SUM(high_school_student_count) AS high_school_student_count,
        SUM(twelfth_grade_count) AS senior_denominator,
        SUM(had_mse_denominator) AS mse_denominator, 
        SUM(four_year_retention_denominator) AS four_year_retention_denominator,
        SUM(on_track_denominator) AS on_track_denominator,
        SUM(grade_rate_6_years_current_class_denom) AS grade_rate_6_years_current_class_denom,
    
    --Seniors with GPA 3.25+ and Composite Ready (55%)
        SUM(above_325_gpa_and_test_ready_seniors) AS above_325_gpa_test_ready_numerator,
    
    --9th grade students are male (50%)
        SUM(male) AS incoming_male_numerator,
    
    --9th grade students are low-income and first-generation (80%)
        SUM(
            CASE WHEN (first_gen = 1 AND low_income = 1) THEN 1 ELSE 0
            END
            ) AS first_gen_low_income_numerator,
    
    --Students with meaningful summer experiences (85%)
        SUM(had_mse_numerator) AS mse_numerator,
    
    --Students growing toward average or above social-emotional strengths
    
    --High school students retained annually (90%)
        SUM(four_year_retention_numerator) AS four_year_retention_numerator,
                
    --High school capacity enrolled (95%); FY21 outcome to be manually entered
    
    --Students matriculating to Best Fit, Good Fit, or Situational Best Fit colleges (50%)
        SUM(matriculated_best_good_situational) AS matriculated_best_good_situational_numerator,
    
    --Students with enough credits accumulated to graduate in 6 years
        SUM(on_track_numerator) AS on_track_numerator,
    
    --Students graduating from college within 6 years (70%)
        SUM(grade_rate_6_years_current_class_numerator) AS grade_rate_6_years_current_class_numerator,
    
    --Graduates with full-time employment or enrolled in graduate school within 6 months of graduation (65%)
    
    --Graduates meeting gainful employment standard (85%)
    
    --Graduates with meaningful employment (85%)
   FROM  `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics` 
   GROUP BY 
        if_site_sort,
        site_short,
        region_short
)
SELECT *
FROM fy21_measures