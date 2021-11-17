#transposing org_scorecard_fy21 table for Data Studio usage
    
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
            ELSE site_short
       END)
       ; 
CREATE TEMP TABLE add_national AS
    SELECT * 
    FROM  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
        ;
INSERT INTO add_national (site_short) VALUES ('National')
        ;
/*
CREATE OR REPLACE TABLE `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21_tranposed`
OPTIONS
    (
    description="This table pulls org scorecard program outcomes for fy21.  Does not include numerator / denominators. Does not include graduate/employment outcomes, annual fundraising outcomes, hs capacity, or hr-related outcomes." 
    )
    AS
    */
WITH national_values AS( --transform Account field, and add Grand Total to National
     SELECT 
        * EXCEPT (fiscal_year
        ,percent_male_fy21  
        ,percent_low_income_first_gen_fy21  
        ,percent_annual_retention_fy21  
        ,percent_social_emotional_growth_fy21   
        ,percent_seniors_above_325_fy21 
        ,percent_seniors_above_325_and_test_ready_fy21  
        ,percent_matriculate_best_good_situational_fy21 
        ,percent_on_track_fy21  
        ,percent_6_year_grad_rate_fy21
        ,percent_mse_fy21),
        CASE WHEN site_short = 'National' THEN male_numerator/ninth_grade_denominator ELSE percent_male_fy21 END AS percent_male_fy21,
        CASE WHEN site_short = 'National' THEN low_income_first_gen_numerator/ninth_grade_denominator ELSE percent_low_income_first_gen_fy21 END AS percent_low_income_first_gen_fy21,
        CASE WHEN site_short = 'National' THEN annual_retention_numerator/annual_retention_denominator ELSE percent_annual_retention_fy21 END AS percent_annual_retention_fy21,
        CASE WHEN site_short = 'National' THEN mse_numerator/mse_denominator ELSE percent_male_fy21 END AS percent_mse_fy21,
        CASE WHEN site_short = 'National' THEN social_emotional_growth_numerator/social_emotional_growth_denominator ELSE percent_male_fy21 END AS percent_social_emotional_growth_fy21,
        CASE WHEN site_short = 'National' THEN above_325_gpa_seniors_numerator/senior_325_gpa_only_denominator ELSE percent_male_fy21 END AS percent_seniors_above_325_fy21,
        CASE WHEN site_short = 'National' THEN senior_325_gpa_and_test_ready_numerator/senior_325_gpa_and_test_ready_denominator ELSE percent_male_fy21 END AS percent_seniors_above_325_and_test_ready_fy21,
        CASE WHEN site_short = 'National' THEN matriculated_best_good_situational_numerator/matriculation_senior_denominator ELSE percent_male_fy21 END AS percent_matriculate_best_good_situational_fy21,
        CASE WHEN site_short = 'National' THEN on_track_numerator/on_track_denominator ELSE percent_male_fy21 END AS percent_on_track_fy21,
        CASE WHEN site_short = 'National' THEN six_yr_grad_rate_numerator/grade_rate_6_years_current_class_denom ELSE percent_male_fy21 END AS percent_6_year_grad_rate_fy21,
        CASE WHEN fiscal_year IS NULL THEN 'FY21' ELSE fiscal_year END AS fiscal_year
    FROM 
        (SELECT * EXCEPT (male_numerator, 
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
        ,mse_denominator),
            CASE WHEN site_short = 'National' THEN SUM(male_numerator) OVER () ELSE male_numerator END AS male_numerator, --pull grand total, add value only to National
            CASE WHEN site_short = 'National' THEN SUM(low_income_first_gen_numerator) OVER () ELSE low_income_first_gen_numerator END AS low_income_first_gen_numerator, 
            CASE WHEN site_short = 'National' THEN SUM(ninth_grade_denominator)OVER () ELSE ninth_grade_denominator END AS ninth_grade_denominator,
            CASE WHEN site_short = 'National' THEN SUM(annual_retention_numerator)OVER () ELSE annual_retention_numerator END AS annual_retention_numerator,
            CASE WHEN site_short = 'National' THEN SUM(annual_retention_denominator)OVER () ELSE annual_retention_denominator END AS annual_retention_denominator,
            CASE WHEN site_short = 'National' THEN SUM(mse_numerator) OVER () ELSE mse_numerator END AS mse_numerator,
            CASE WHEN site_short = 'National' THEN SUM(mse_denominator) OVER () ELSE mse_denominator END AS mse_denominator,
            CASE WHEN site_short = 'National' THEN SUM(social_emotional_growth_numerator) OVER () ELSE social_emotional_growth_numerator END AS social_emotional_growth_numerator,
            CASE WHEN site_short = 'National' THEN SUM(social_emotional_growth_denominator) OVER () ELSE social_emotional_growth_denominator END AS social_emotional_growth_denominator,
            CASE WHEN site_short = 'National' THEN SUM(above_325_gpa_seniors_numerator) OVER () ELSE above_325_gpa_seniors_numerator END AS above_325_gpa_seniors_numerator,
            CASE WHEN site_short = 'National' THEN SUM(senior_325_gpa_only_denominator) OVER () ELSE senior_325_gpa_only_denominator END AS senior_325_gpa_only_denominator,
            CASE WHEN site_short = 'National' THEN SUM(senior_325_gpa_and_test_ready_numerator) OVER () ELSE senior_325_gpa_and_test_ready_numerator END AS senior_325_gpa_and_test_ready_numerator,
            CASE WHEN site_short = 'National' THEN SUM(senior_325_gpa_and_test_ready_denominator) OVER () ELSE senior_325_gpa_and_test_ready_denominator END AS senior_325_gpa_and_test_ready_denominator,
            CASE WHEN site_short = 'National' THEN SUM(matriculated_best_good_situational_numerator) OVER () ELSE matriculated_best_good_situational_numerator END AS matriculated_best_good_situational_numerator,
            CASE WHEN site_short = 'National' THEN SUM(matriculation_senior_denominator) OVER () ELSE matriculation_senior_denominator END AS matriculation_senior_denominator,
            CASE WHEN site_short = 'National' THEN SUM(on_track_numerator) OVER () ELSE on_track_numerator END AS on_track_numerator,
            CASE WHEN site_short = 'National' THEN SUM(on_track_denominator) OVER () ELSE on_track_denominator END AS on_track_denominator,
            CASE WHEN site_short = 'National' THEN SUM(six_yr_grad_rate_numerator) OVER () ELSE six_yr_grad_rate_numerator END AS six_yr_grad_rate_numerator,
            CASE WHEN site_short = 'National' THEN SUM(grade_rate_6_years_current_class_denom) OVER () ELSE grade_rate_6_years_current_class_denom END AS grade_rate_6_years_current_class_denom
        FROM add_national)
)
,unnesting AS (
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
        --,alumni_count   
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
    FROM national_values
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
        --,alumni_count   
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
    ]) 
AS measure_component
)

, map_region_and_site_to_account AS (
    SELECT * EXCEPT (site_short,region_short), mapSiteAbbrev(site_short) AS Account --map Site to site_abbrev
    FROM unnesting where site_short IS NOT NULL
    UNION DISTINCT
    SELECT * EXCEPT (site_short,region_short), mapRegionAbbrev(region_short) AS Account --map region to region_abbrev
    FROM unnesting where region_short IS NOT NULL
)
, set_measure AS (
    SELECT DISTINCT
    a.fiscal_year,
    Account,
    measure_component, 
--map tranposed 'value' column to >> 'measure_component' column in the org_scorecard fy21 table (e.g. "percent_male_fy21")
CASE WHEN (value = low_income_first_gen_numerator AND measure_component = 'low_income_first_gen_numerator' AND mapSiteAbbrev(site_short) = Account) THEN value 
        WHEN (value = ninth_grade_denominator AND measure_component = 'ninth_grade_denominator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = male_numerator AND measure_component = 'male_numerator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = annual_retention_numerator AND measure_component = 'annual_retention_numerator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = annual_retention_denominator AND measure_component = 'annual_retention_denominator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = percent_male_fy21 AND measure_component = 'percent_male_fy21' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = percent_low_income_first_gen_fy21 AND measure_component = 'percent_low_income_first_gen_fy21' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = percent_annual_retention_fy21 AND measure_component = 'percent_annual_retention_fy21' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = social_emotional_growth_numerator AND measure_component = 'social_emotional_growth_numerator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = social_emotional_growth_denominator AND measure_component = 'social_emotional_growth_denominator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = above_325_gpa_seniors_numerator AND measure_component = 'above_325_gpa_seniors_numerator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = senior_325_gpa_and_test_ready_numerator AND measure_component = 'senior_325_gpa_and_test_ready_numerator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = senior_325_gpa_only_denominator AND measure_component = 'senior_325_gpa_only_denominator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = senior_325_gpa_and_test_ready_denominator AND measure_component = 'senior_325_gpa_and_test_ready_denominator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = mse_numerator AND measure_component = 'mse_numerator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = mse_denominator AND measure_component = 'mse_denominator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = percent_seniors_above_325_fy21 AND measure_component = 'percent_seniors_above_325_fy21' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = percent_seniors_above_325_and_test_ready_fy21 AND measure_component = 'percent_seniors_above_325_and_test_ready_fy21' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = percent_social_emotional_growth_fy21 AND measure_component = 'percent_social_emotional_growth_fy21' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = percent_mse_fy21 AND measure_component = 'percent_mse_fy21' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = matriculated_best_good_situational_numerator AND measure_component = 'matriculated_best_good_situational_numerator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = matriculation_senior_denominator AND measure_component = 'matriculation_senior_denominator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = on_track_numerator AND measure_component = 'on_track_numerator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = on_track_denominator AND measure_component = 'on_track_denominator' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = six_yr_grad_rate_numerator AND measure_component = 'six_yr_grad_rate_numerator AND site_short = Account') THEN value
        WHEN (value = grade_rate_6_years_current_class_denom AND measure_component = 'grade_rate_6_years_current_class_denom' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = percent_matriculate_best_good_situational_fy21 AND measure_component = 'percent_matriculate_best_good_situational_fy21' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = percent_on_track_fy21 AND measure_component = 'percent_on_track_fy21' AND mapSiteAbbrev(site_short) = Account) THEN value
        WHEN (value = percent_6_year_grad_rate_fy21 AND measure_component = 'percent_6_year_grad_rate_fy21' AND mapSiteAbbrev(site_short) = Account) THEN value
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
LEFT JOIN national_values AS B ON B.fiscal_year =A.fiscal_year 
GROUP BY Account,measure_component,value,measure,fiscal_year,site_short 
)
, map_objective AS (
    SELECT DISTINCT *, mapObjective(Measure) AS Objective
    FROM set_measure
    WHERE value is not null
)
,pull_outcomes AS (
    SELECT *
    FROM map_objective
    --WHERE measure_component LIKE '%_fy21%' --only pull outcome/percentages for each measure
)
, transpose AS (
    SELECT *
    FROM 
        (SELECT * FROM pull_outcomes )
    PIVOT (MAX(value) FOR Account --pivot outcomes as row values
        IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','DC8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION'))
    ORDER BY Objective 
)

,map_region_outcomes AS (
SELECT  * EXCEPT (NORCAL,LA,CO,DC,NATIONAL),
    CASE WHEN measure_component LIKE "%_numerator%" THEN (IFNULL(EPA, 0) + (IFNULL(OAK, 0) + IFNULL(SF, 0) + IFNULL(SAC, 0)))
    WHEN measure_component LIKE "%_denominator%" THEN (IFNULL(EPA, 0) + (IFNULL(OAK, 0) + IFNULL(SF, 0) + IFNULL(SAC, 0)))END AS NORCAL,

    CASE WHEN measure_component LIKE "%_numerator%" THEN (IFNULL(BH, 0) + (IFNULL(WATTS, 0) + IFNULL(CREN, 0)))
    WHEN measure_component LIKE "%_denominator%" THEN (IFNULL(BH, 0) + (IFNULL(WATTS, 0) + IFNULL(CREN, 0)))END AS LA,

    CASE WHEN measure_component LIKE "%_numerator%" THEN (IFNULL(AUR, 0) + IFNULL(DEN, 0))
    WHEN measure_component LIKE "%_denominator%" THEN (IFNULL(AUR, 0) + IFNULL(DEN, 0)) END AS CO,

    CASE WHEN measure_component LIKE "%_numerator%" THEN (IFNULL(PGC, 0) + IFNULL(DC8, 0)) 
    WHEN measure_component LIKE "%_denominator%" THEN (IFNULL(PGC, 0) + IFNULL(DC8, 0)) END AS DC,
    
FROM transpose
GROUP BY 
    fiscal_year,
    measure_component,
    measure,
    objective,
    NOLA,
    NOLA_RG,
    NATIONAL,
    NATIONAL_AS_LOCATION,
    EPA,
    OAK,
    SF,
    SAC,
    BH,
    WATTS,
    CREN,
    AUR,
    DEN,
    PGC,
    DC8
)

SELECT a.* EXCEPT (NORCAL,LA,CO,DC),
        b.NORCAL,
        b.LA,
        b.CO,
        b.DC,
    FROM transpose AS a
LEFT JOIN map_region_outcomes AS b ON a.measure_component=b.measure_component 