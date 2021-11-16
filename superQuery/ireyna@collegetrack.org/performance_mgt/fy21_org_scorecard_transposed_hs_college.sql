
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
)
--, set_measure AS (
    SELECT DISTINCT
    a.fiscal_year,
    Account,
    measure_component,
--map tranposed 'value' column to >> 'measure_component' column in the org_scorecard fy21 table (e.g. "percent_male_fy21")
CASE WHEN (value = low_income_first_gen_numerator AND measure_component = 'low_income_first_gen_numerator') THEN value 
        WHEN (value = ninth_grade_denominator AND measure_component = 'ninth_grade_denominator') THEN value
        WHEN (value = male_numerator AND measure_component = 'male_numerator') THEN value
        WHEN (value = annual_retention_numerator AND measure_component = 'annual_retention_numerator') THEN value
        WHEN (value = annual_retention_denominator AND measure_component = 'annual_retention_denominator') THEN value
        WHEN (value = percent_male_fy21 AND measure_component = 'percent_male_fy21') THEN value
        WHEN (value = percent_low_income_first_gen_fy21 AND measure_component = 'percent_low_income_first_gen_fy21') THEN value
        WHEN (value = percent_annual_retention_fy21 AND measure_component = 'percent_annual_retention_fy21') THEN value
        WHEN (value = social_emotional_growth_numerator AND measure_component = 'social_emotional_growth_numerator') THEN value
        WHEN (value = social_emotional_growth_denominator AND measure_component = 'social_emotional_growth_denominator') THEN value
        WHEN (value = above_325_gpa_seniors_numerator AND measure_component = 'above_325_gpa_seniors_numerator') THEN value
        WHEN (value = senior_325_gpa_and_test_ready_numerator AND measure_component = 'senior_325_gpa_and_test_ready_numerator') THEN value
        WHEN (value = senior_325_gpa_only_denominator AND measure_component = 'senior_325_gpa_only_denominator') THEN value
        WHEN (value = senior_325_gpa_and_test_ready_denominator AND measure_component = 'senior_325_gpa_and_test_ready_denominator') THEN value
        WHEN (value = mse_numerator AND measure_component = 'mse_numerator') THEN value
        WHEN (value = mse_denominator AND measure_component = 'mse_denominator') THEN value
        WHEN (value = percent_seniors_above_325_fy21 AND measure_component = 'percent_seniors_above_325_fy21') THEN value
        WHEN (value = percent_seniors_above_325_and_test_ready_fy21 AND measure_component = 'percent_seniors_above_325_and_test_ready_fy21') THEN value
        WHEN (value = percent_social_emotional_growth_fy21 AND measure_component = 'percent_social_emotional_growth_fy21') THEN value
        WHEN (value = percent_mse_fy21 AND measure_component = 'percent_mse_fy21') THEN value
        WHEN (value = matriculated_best_good_situational_numerator AND measure_component = 'matriculated_best_good_situational_numerator') THEN value
        WHEN (value = matriculation_senior_denominator AND measure_component = 'matriculation_senior_denominator') THEN value
        WHEN (value = on_track_numerator AND measure_component = 'on_track_numerator') THEN value
        WHEN (value = on_track_denominator AND measure_component = 'on_track_denominator') THEN value
        WHEN (value = six_yr_grad_rate_numerator AND measure_component = 'six_yr_grad_rate_numerator') THEN value
        WHEN (value = grade_rate_6_years_current_class_denom AND measure_component = 'grade_rate_6_years_current_class_denom') THEN value
        WHEN (value = percent_matriculate_best_good_situational_fy21 AND measure_component = 'percent_matriculate_best_good_situational_fy21') THEN value
        WHEN (value = percent_on_track_fy21 AND measure_component = 'percent_on_track_fy21') THEN value
        WHEN (value = percent_6_year_grad_rate_fy21 AND measure_component = 'percent_6_year_grad_rate_fy21') THEN value
    ELSE NULL END AS value,
--Map Measure based on measure_component
CASE WHEN measure_component = 'male_numerator' THEN 'recruit_and_retain'
    WHEN measure_component = 'low_income_first_gen_numerator' THEN 'recruit_and_retain'
    WHEN measure_component = 'ninth_grade_denominator' THEN 'recruit_and_retain'
    WHEN measure_component = 'annual_retention_numerator' THEN 'recruit_and_retain'
    WHEN measure_component = 'ninth_grade_denominator' THEN 'recruit_and_retain'
    WHEN measure_component = 'annual_retention_denominator' THEN 'recruit_and_retain'
    WHEN measure_component = 'percent_male_fy21' THEN 'recruit_and_retain'                             
    WHEN measure_component = 'percent_low_income_first_gen_fy21' THEN 'recruit_and_retain'
    WHEN measure_component = 'percent_annual_retention_fy21' THEN 'recruit_and_retain'     
    WHEN measure_component = 'annual_retention_denominator' THEN 'recruit_and_retain'
    WHEN measure_component = 'percent_male_fy21' THEN 'recruit_and_retain'                             
    WHEN measure_component = 'percent_low_income_first_gen_fy21' THEN 'recruit_and_retain'
    WHEN measure_component = 'percent_annual_retention_fy21' THEN 'recruit_and_retain' 
    WHEN measure_component = 'social_emotional_growth_numerator' THEN 'social_emotional_academic_foundation'
    WHEN measure_component = 'social_emotional_growth_denominator' THEN 'social_emotional_academic_foundation'
    WHEN measure_component = 'percent_social_emotional_growth_fy21' THEN 'social_emotional_academic_foundation'
    WHEN measure_component = 'above_325_gpa_seniors_numerator' THEN 'social_emotional_academic_foundation'
    WHEN measure_component = 'senior_325_gpa_and_test_ready_numerator' THEN 'social_emotional_academic_foundation'                             
    WHEN measure_component = 'senior_325_gpa_only_denominator' THEN 'social_emotional_academic_foundation'
    WHEN measure_component = 'senior_325_gpa_and_test_ready_denominator' THEN 'social_emotional_academic_foundation'    
    WHEN measure_component = 'mse_numerator' THEN 'social_emotional_academic_foundation'                             
    WHEN measure_component = 'mse_denominator' THEN 'social_emotional_academic_foundation'
    WHEN measure_component = 'percent_social_emotional_growth_fy21' THEN 'social_emotional_academic_foundation'
    WHEN measure_component = 'percent_seniors_above_325_fy21' THEN 'social_emotional_academic_foundation'  
    WHEN measure_component = 'percent_seniors_above_325_and_test_ready_fy21' THEN 'social_emotional_academic_foundation'  
    WHEN measure_component = 'percent_mse_fy21' THEN 'social_emotional_academic_foundation'     
    WHEN measure_component = 'matriculated_best_good_situational_numerator' THEN 'college_students'                             
    WHEN measure_component = 'matriculation_senior_denominator' THEN 'college_students'
    WHEN measure_component = 'on_track_numerator' THEN 'college_students'     
    WHEN measure_component = 'on_track_denominator' THEN 'college_students'
    WHEN measure_component = 'six_yr_grad_rate_numerator' THEN 'college_students'                             
    WHEN measure_component = 'grade_rate_6_years_current_class_denom' THEN 'college_students'
    WHEN measure_component = 'percent_matriculate_best_good_situational_fy21' THEN 'college_students'         
    WHEN measure_component = 'percent_on_track_fy21' THEN 'college_students'  
    WHEN measure_component = 'percent_6_year_grad_rate_fy21' THEN 'college_students' 
    ELSE null 
    END AS measure
FROM map_region_and_site_to_account AS A
LEFT JOIN `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21` AS B ON B.fiscal_year =A.fiscal_year 
