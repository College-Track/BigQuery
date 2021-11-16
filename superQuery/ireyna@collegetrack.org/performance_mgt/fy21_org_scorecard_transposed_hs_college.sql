
CREATE TEMPORARY FUNCTION mapObjective(Measure STRING) AS ( --Populate "Objective" column based on value in "Measure" column
   CASE 
            WHEN Measure LIKE '%recruit_and_retain%' THEN 'Objective_1'
            WHEN Measure LIKE '%social_emotional_academic_foundation%' THEN 'Objective_2'
            WHEN Measure LIKE '%college_students%' THEN 'Objective_3'
        END)
        ;
CREATE TEMPORARY FUNCTION mapRegionAbbrev (region_short STRING) AS ( --Remap abbreviated Account names to site_short
   CASE 
            WHEN region_short = 'Northern California' THEN 'NORCAL'
            WHEN region_short = 'Los Angeles' THEN 'LA'
            WHEN region_short = 'New Orleans' THEN 'NOLA_RG'
            WHEN region_short = 'Colorado' THEN 'CO'
            WHEN region_short = 'Washington DC' THEN 'DC'
            WHEN region_short = 'National' THEN 'NATIONAL'
            WHEN region_short = 'NATIONAL (AS LOCATION)' THEN region_short
       END)
       ;
CREATE TEMPORARY FUNCTION mapSiteAbbrev (site_short STRING) AS ( --Remap abbreviated Account names to site_short
   CASE 
            WHEN site_short = 'East Palo Alto' THEN 'EPA'
            WHEN site_short = 'Oakland' THEN 'OAK'
            WHEN site_short = 'San Francisco' THEN 'SF'
            WHEN site_short = 'New Orleans' THEN 'NOLA'
            WHEN site_short = 'Aurora' THEN 'AUR'
            WHEN site_short = 'Boyle Heights' THEN 'BH'
            WHEN site_short = 'Sacramento' THEN 'SAC'
            WHEN site_short = 'Watts' THEN 'WATTS'
            WHEN site_short = 'Denver' THEN 'DEN'
            WHEN site_short = 'The Durant Center' THEN 'PGC'
            WHEN site_short = 'Ward 8' THEN 'DC8'
            WHEN site_short = 'Crenshaw' THEN 'CREN'
            WHEN site_short = 'National' THEN 'NATIONAL'
            WHEN site_short = 'NATIONAL (AS LOCATION)' THEN site_short
       END)
       ; 
WITH unnesting AS (
    SELECT * EXCEPT (
        male_numerator, 
        low_income_first_gen_numerator, 
        ninth_grade_denominator,
        annual_retention_numerator, 
        annual_retention_denominator,   
        social_emotional_growth_numerator,  
        social_emotional_growth_denominator,    
        above_325_gpa_seniors_numerator ,
        senior_325_gpa_and_test_ready_numerator 
        ,senior_325_gpa_only_denominator    
        ,senior_325_gpa_and_test_ready_denominator  
        ,matriculated_best_good_situational_numerator   
        ,matriculation_senior_denominator   
        ,on_track_numerator 
        ,on_track_denominator   
        ,six_yr_grad_rate_numerator 
        ,grade_rate_6_years_current_class_denom 
        ,alumni_count   
        ,mse_numerator  
        ,mse_denominator    
        ,percent_male_fy21  
        ,percent_low_income_first_gen_fy21  
        ,percent_annual_retention_fy21  
        ,percent_mse_fy21
        ,percent_social_emotional_growth_fy21   
        ,percent_seniors_above_325_fy21 
        ,percent_seniors_above_325_and_test_ready_fy21  
        ,percent_matriculate_best_good_situational_fy21 
        ,percent_on_track_fy21  
        ,percent_6_year_grad_rate_fy21
        )
    FROM `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21` 
    CROSS JOIN
    UNNEST([ --unnest values per field: numerators, denominators, percents/outcomes
        male_numerator
        ,low_income_first_gen_numerator
        ,ninth_grade_denominator
        ,annual_retention_numerator
        ,annual_retention_denominator  
        ,social_emotional_growth_numerator
        ,social_emotional_growth_denominator   
        ,above_325_gpa_seniors_numerator 
        ,senior_325_gpa_and_test_ready_numerator 
        ,senior_325_gpa_only_denominator    
        ,senior_325_gpa_and_test_ready_denominator  
        ,matriculated_best_good_situational_numerator   
        ,matriculation_senior_denominator   
        ,on_track_numerator 
        ,on_track_denominator   
        ,six_yr_grad_rate_numerator 
        ,grade_rate_6_years_current_class_denom 
        ,alumni_count   
        ,mse_numerator  
        ,mse_denominator    
        ,percent_male_fy21  
        ,percent_low_income_first_gen_fy21  
        ,percent_annual_retention_fy21  
        ,percent_social_emotional_growth_fy21   
        ,percent_seniors_above_325_fy21 
        ,percent_seniors_above_325_and_test_ready_fy21  
        ,percent_matriculate_best_good_situational_fy21 
        ,percent_on_track_fy21  
        ,percent_6_year_grad_rate_fy21
        ,percent_mse_fy21
        ]) AS value
    CROSS JOIN 
    UNNEST ([ --unnest part of measure associated with each value
        'male_numerator'  
        ,'low_income_first_gen_numerator'
        ,'ninth_grade_denominator'
        ,'annual_retention_numerator'
        ,'annual_retention_denominator'  
        ,'social_emotional_growth_numerator'  
        ,'social_emotional_growth_denominator'    
        ,'above_325_gpa_seniors_numerator '
        ,'senior_325_gpa_and_test_ready_numerator'
        ,'senior_325_gpa_only_denominator '   
        ,'senior_325_gpa_and_test_ready_denominator ' 
        ,'matriculated_best_good_situational_numerator '  
        ,'matriculation_senior_denominator'   
        ,'on_track_numerator' 
        ,'on_track_denominator'   
        ,'six_yr_grad_rate_numerator' 
        ,'grade_rate_6_years_current_class_denom' 
        ,'alumni_count'   
        ,'mse_numerator'  
        ,'mse_denominator'    
        ,'percent_male_fy21'  
        ,'percent_low_income_first_gen_fy21'  
        ,'percent_annual_retention_fy21'  
        ,'percent_social_emotional_growth_fy21'   
        ,'percent_seniors_above_325_fy21' 
        ,'percent_seniors_above_325_and_test_ready_fy21'  
        ,'percent_matriculate_best_good_situational_fy21' 
        ,'percent_on_track_fy21'
        ,'percent_mse_fy21'
        ,'percent_6_year_grad_rate_fy21'
    ]) AS measure_component
)

--, map_region_and_site_to_account AS (
    SELECT * EXCEPT (site_short,region_short), mapSiteAbbrev(site_short) AS Account --map Site to site_abbrev
    FROM unnesting where site_short IS NOT NULL
    UNION DISTINCT
    SELECT * EXCEPT (site_short,region_short), mapRegionAbbrev(region_short) AS Account --map region to region_abbrev
    FROM unnesting