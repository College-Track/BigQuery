#Using data-studio-260217.performance_mgt.fy21_eoy_combined_metrics table

--site breakdown
    SELECT
        if_site_sort,
        site_short,
    --GPA data
        above_3_gpa AS students_above_3_gpa_numerator,
        above_325_gpa_seniors AS above_325_gpa_seniors_numerator,
        above_325_gpa_and_test_ready_seniors AS above_325_gpa_and_test_ready_seniors_numerator,
        high_school_student_count AS hs_students_denominator,
        non_opt_out_seniors AS senior_readiness_gpa_opt_ins_denominator,
        
    --matriculation data
        matriculation_numerator AS num_matriculation,
        matriculated_affordable AS num_matriculation_affordable,
        matriculated_best_good_situational AS num_matriculated_best_good_situational,
        college_first_enrolled_school_type_numerator AS matriculation_4yr,
        twelfth_grade_count AS senior_denominator,
        
    --persistence data
        indicator_persisted_into_2_nd_year_ct_numerator AS num_persistence,
        persistence_denominator,
    
    --on-track data
        on_track_numerator,
        on_track_denominator,
    
    --college students graduating with 1+ internship
        had_1_plus_internship_numerator,
        had_1_plus_internship_denominator,
        
    --6 year graduation rate
        grade_rate_6_years_current_class_numerator AS num_6_yr_grad_rate,
        grade_rate_6_years_current_class_denom,
    
    --alumni
        alumni_count,
        
    --MEMO data
        had_mse_numerator AS mse_numerator,
        had_mse_denominator AS mse_denominator,
        
        above_80_attendance_memo AS above_80_attendance_memo_orig,
        CASE WHEN above_80_attendance = 0 AND above_80_attendance_memo = 1
            THEN above_80_attendance_memo  ELSE above_80_attendance
            END AS attendance_numerator_memo,
        high_school_student_count

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`  
    ;
--region breakdown
SELECT
    
        region_short,
        
        SUM(matriculation_numerator) AS num_matriculation,
        SUM(matriculated_affordable) AS num_matriculation_affordable,
        SUM(matriculated_best_good_situational) AS num_matriculated_best_good_situational,
        SUM(college_first_enrolled_school_type_numerator) AS matriculation_4yr,
        SUM(twelfth_grade_count) AS senior_denominator,
    
    --3.0 & 3.25 GPA data
        SUM(above_3_gpa)AS students_above_3_gpa_numerator,
        SUM(above_325_gpa_seniors) AS above_325_gpa_seniors_numerator,
        SUM(above_325_gpa_and_test_ready_seniors) AS above_325_gpa_and_test_ready_seniors_numerator,
        SUM(high_school_student_count) AS hs_students_denominator,
        SUM(non_opt_out_seniors) AS senior_readiness_gpa_opt_ins_denominator,
        
    --persistence data
        SUM(indicator_persisted_into_2_nd_year_ct_numerator) AS num_persistence,
        SUM(persistence_denominator) AS persistence_denominator,
    
    --on-track data
        SUM(on_track_numerator) AS on_track_numerator,
        SUM(on_track_denominator) AS on_track_denominator,
    
    --college students graduating with 1+ internship
        SUM(had_1_plus_internship_numerator) AS had_1_plus_internship_numerator,
        SUM(had_1_plus_internship_denominator) AS had_1_plus_internship_denominator,
        
    --6 year graduation rate
        SUM(grade_rate_6_years_current_class_numerator) AS num_6_yr_grad_rate,
        SUM(grade_rate_6_years_current_class_denom) AS grade_rate_6_years_current_class_denom,
    
    --alumni
        SUM(alumni_count) AS alumni_count,
    
    --MEMO data
        SUM(had_mse_numerator) AS mse_numerator,
        SUM(had_mse_denominator) AS mse_denominator,
        
        SUM(above_80_attendance_memo) AS above_80_attendance_memo_orig,
        
        SUM(CASE WHEN above_80_attendance = 0 AND above_80_attendance_memo = 1
            THEN above_80_attendance_memo  ELSE above_80_attendance
            END) AS attendance_numerator_memo,
        SUM(high_school_student_count) AS high_school_student_count,

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`
    GROUP BY
        region_short
;
/*
--Using FY21_eoy_combined_metrics table to consolidate org scorecard data
/*
    

    Strategy Team representing a spectrum of identities above average nonprofit benchmarks*
    Annual Fundraising target (100%)
    Staff with full-time tenure of 3+ years in organization (35%)
  
    Staff engagement score above average nonprofit benchmark (Y)


#UNION TESTS



CREATE TEMPORARY FUNCTION mapSite (Account STRING) AS ( --Remap abbreviated Account names to site_short
   CASE 
            WHEN Account = 'College Track East Palo Alto' THEN 'East Palo Alto'
            WHEN Account = 'College Track Oakland' THEN 'Oakland'
            WHEN Account = 'College Track San Francisco' THEN 'San Francisco'
            WHEN Account = 'College Track New Orleans' THEN 'New Orleans'
            WHEN Account = 'College Track Aurora' THEN 'Aurora'
            WHEN Account = 'College Track Boyle Heights' THEN 'Boyle Heights'
            WHEN Account = 'College Track Sacramento' THEN 'Sacramento'
            WHEN Account = 'College Track Watts' THEN 'Watts'
            WHEN Account = 'College Track Denver' THEN 'Denver'
            WHEN Account = 'College Track at The Durant Center' THEN 'The Durant Center'
            WHEN Account = 'College Track Ward 8' THEN 'Ward 8'
            WHEN Account = 'College Track Crenshaw' THEN 'Crenshaw'
            WHEN Account = 'EPA' THEN 'East Palo Alto'
            WHEN Account = 'OAK' THEN 'Oakland'
            WHEN Account = 'SF' THEN 'San Francisco'
            WHEN Account = 'NOLA' THEN 'New Orleans'
            WHEN Account = 'AUR' THEN 'Aurora'
            WHEN Account = 'BH' THEN 'Boyle Heights'
            WHEN Account = 'SAC' THEN 'Sacramento'
            WHEN Account = 'WATTS' THEN 'Watts'
            WHEN Account = 'DEN' THEN 'Denver'
            WHEN Account = 'PGC' THEN 'The Durant Center'
            WHEN Account = 'DC8' THEN 'Ward 8'
            WHEN Account = 'CREN' THEN 'Crenshaw'
            WHEN Account = 'NATIONAL' THEN 'National'
            WHEN Account = 'National' THEN 'National'
            WHEN Account = 'NATIONAL (AS LOCATION)'THEN 'National (As Location)'
       END)
       ;
CREATE TEMPORARY FUNCTION mapRegion(Account STRING) AS ( --map Region based on Site, remap region abbreviations to region_short
    CASE 
            WHEN Account = 'College Track Northern California Region' THEN 'Northern California Region'
            WHEN Account = 'College Track New Orleans Region' THEN 'New Orleans Region'
            WHEN Account = 'College Track Colorado Region' THEN 'Colorado Region'
            WHEN Account = 'College Track Los Angeles Region' THEN 'Los Angeles Region'
            WHEN Account = 'College Track DC Region' THEN 'DC Region'
            WHEN Account = 'EPA' THEN 'Northern California Region'
            WHEN Account = 'OAK' THEN 'Northern California Region'
            WHEN Account = 'SF' THEN 'Northern California Region'
            WHEN Account = 'NOLA' THEN 'New Orleans Region'
            WHEN Account = 'AUR' THEN 'Colorado Region'
            WHEN Account = 'BH' THEN 'Los Angeles Region'
            WHEN Account = 'SAC' THEN 'Northern California Region'
            WHEN Account = 'WATTS' THEN 'Los Angeles Region'
            WHEN Account = 'DEN' THEN 'Colorado Region'
            WHEN Account = 'PGC' THEN 'DC Region'
            WHEN Account = 'DC8' THEN 'DC Region'
            WHEN Account = 'CREN' THEN 'Los Angeles Region'
            WHEN Account = 'NATIONAL' THEN 'National'
            WHEN Account = 'National' THEN 'National'
            WHEN Account = 'NATIONAL (AS LOCATION)' THEN 'National (As Location)'
            WHEN Account = 'NORCAL' THEN 'Northern California Region'
            WHEN Account = 'LA' THEN 'Los Angeles Region'
            WHEN Account = 'CO' THEN 'Colorado Region'
            WHEN Account = 'NOLA' THEN 'New Orleans Region'
            WHEN Account = 'DC' THEN 'DC Region'
            WHEN Account = 'College Track East Palo Alto' THEN 'Northern California Region'
            WHEN Account = 'College Track Oakland' THEN 'Northern California Region'
            WHEN Account = 'College Track San Francisco' THEN 'Northern California Region'
            WHEN Account = 'College Track New Orleans' THEN 'New Orleans Region'
            WHEN Account = 'College Track Aurora' THEN 'Colorado Region'
            WHEN Account = 'College Track Boyle Heights' THEN 'Los Angeles Region'
            WHEN Account = 'College Track Sacramento' THEN 'Northern California Region'
            WHEN Account = 'College Track Watts' THEN 'Los Angeles Region'
            WHEN Account = 'College Track Denver' THEN 'Colorado Region'
            WHEN Account = 'College Track at The Durant Center' THEN 'DC Region'
            WHEN Account = 'College Track Ward 8' THEN 'DC Region'
            WHEN Account = 'College Track Crenshaw' THEN 'Los Angeles Region'
        END)
        ;
CREATE TEMPORARY FUNCTION mapRegionShort (Account STRING) AS (
        CASE
            WHEN Account = 'East Palo Alto' THEN 'Northern California Region'
            WHEN Account = 'Oakland' THEN 'Northern California Region'
            WHEN Account = 'San Francisco' THEN 'Northern California Region'
            WHEN Account = 'New Orleans' THEN 'New Orleans Region'
            WHEN Account = 'Aurora' THEN 'Colorado Region'
            WHEN Account = 'Boyle Heights' THEN 'Los Angeles Region'
            WHEN Account = 'Sacramento' THEN 'Northern California Region'
            WHEN Account = 'Watts' THEN 'Los Angeles Region'
            WHEN Account = 'Denver' THEN 'Colorado Region'
            WHEN Account = 'The Durant Center' THEN 'DC Region'
            WHEN Account = 'Ward 8' THEN 'DC Region'
            WHEN Account = 'Crenshaw' THEN 'Los Angeles Region'
        END)
        ;
CREATE TEMP TABLE hr_financial_sustainability_hs_capacity AS
(
WITH
financial_sustainability AS (
     SELECT 
            * EXCEPT (site_short, Account),
            mapSite(Account) AS Account, --site_abbrev to site_short 
        FROM `org-scorecard-286421.aggregate_data.financial_sustainability_fy20`
        WHERE Account LIKE '%College Track%' -- only looking at values that are site_long

        UNION DISTINCT

        SELECT 
            * EXCEPT (Account,site_short),
            mapRegion(Account) AS Account --region abrev to region_short
        FROM `org-scorecard-286421.aggregate_data.financial_sustainability_fy20`
        WHERE Account NOT LIKE '%College Track%' --only looking at values that are region_abrev
),

hr_tenure AS ( 
    SELECT 
        * EXCEPT (site,region), 
        mapSite(site) as Account
        FROM`org-scorecard-286421.aggregate_data.HR_outcomes_tenure_engagement`
        WHERE site IS NOT NULL

    UNION DISTINCT

    SELECT 
        * EXCEPT (site,region), 
        mapRegion(region) as Account
        FROM`org-scorecard-286421.aggregate_data.HR_outcomes_tenure_engagement`
        where region IS NOT NULL
),

hr_identities AS (
    SELECT 
        * EXCEPT (Account,string_field_5),
        mapRegion(Account)  AS Account --mapping site names and region abbreviations to region_short
        FROM`org-scorecard-286421.aggregate_data.HR_outcomes_identity`
        WHERE Account IS NOT NULL
),

join_all AS (
SELECT 
    DISTINCT
    A.*,
    B.* EXCEPT (Account),
    C.* EXCEPT (Account)
FROM hr_tenure AS A                    
LEFT JOIN financial_sustainability AS B     ON A.Account = B.Account 
LEFT JOIN hr_identities AS C                ON A.Account = C.Account    
 
)

SELECT 
    *,
    --Account AS site_or_region_hr_finance,
    CONCAT(Account,"_hr_finance_capacity") AS Account_hr_finance, --append 'hr_finance"capacity' to each region/site to differntiate outcomes
    CASE WHEN Account IS NOT NULL THEN 1 ELSE 0 END AS objective_indicator_hr_financial_hs_capacity,   
      
FROM join_all
)
;

WITH 

objective_1_site AS (
    SELECT 
        * EXCEPT (Site__Account_Name,Region__Account_Name),
         CASE WHEN Region__Account_Name = 'NATIONAL' THEN 'National' ELSE mapRegion(Region__Account_Name) END AS Account
        
        FROM `org-scorecard-286421.aggregate_data.objective_1_site`
    
        UNION DISTINCT

     SELECT 
        * EXCEPT (Site__Account_Name,Region__Account_Name),
        CASE WHEN Site__Account_Name = 'NATIONAL' THEN 'National' ELSE mapSite(Site__Account_Name) END AS Account

        FROM `org-scorecard-286421.aggregate_data.objective_1_site`  
),

objective_1_region AS (
    SELECT 
        * EXCEPT (site),
        --mapRegion(site)  AS Account2
        Site AS Account2

    FROM(
        SELECT * EXCEPT (Region), Region AS site
        FROM `org-scorecard-286421.aggregate_data.objective_1_region`
        )
),

college_outcomes AS (
    SELECT 
            * EXCEPT (site_short, Account),
            mapSite(Account) AS Account, --site_abbrev to site_short 
        FROM `org-scorecard-286421.aggregate_data.college_outcomes_fy20`
        WHERE Account LIKE '%College Track%' -- only looking at values that are site_long
        
        UNION DISTINCT 

    SELECT 
            * EXCEPT (Account,site_short),
            mapRegion(Account) AS Account --region abrev to region_short
        FROM  `org-scorecard-286421.aggregate_data.college_outcomes_fy20`
        WHERE Account NOT LIKE '%College Track%' --only looking at values that are region_abrev
),

college_graduates AS (
    SELECT
        * EXCEPT (site_short, Account),
            mapSite(Account) AS Account, --site_abbrev to site_short 
        FROM `org-scorecard-286421.aggregate_data.college_graduates_outcomes_fy20`
        WHERE Account LIKE '%College Track%' -- only looking at values that are site_long

        UNION DISTINCT

    SELECT 
            * EXCEPT (Account,site_short),
            mapRegion(Account) AS Account --region abrev to region_short
        FROM  `org-scorecard-286421.aggregate_data.college_graduates_outcomes_fy20`
        WHERE Account NOT LIKE '%College Track%' --only looking at values that are region_abrev
),

mse_social_emotional_edits AS ( 
    SELECT
        * EXCEPT (site_short, Account),
            mapSite(Account) AS Account, --site_abbrev to site_short 
        FROM `org-scorecard-286421.aggregate_data.HS_MSE_CoVi_FY20`
        WHERE Account LIKE '%College Track%' -- only looking at values that are site_long

        UNION DISTINCT

    SELECT 
            * EXCEPT (Account,site_short),
            mapRegion(Account) AS Account --region abrev to region_short
        FROM  `org-scorecard-286421.aggregate_data.HS_MSE_CoVi_FY20`
        WHERE Account NOT LIKE '%College Track%' --only looking at values that are region_abrev
),

join_all AS (
SELECT 
    DISTINCT
    A.* EXCEPT (National),
    --B.* Account2,
    C.* EXCEPT (Account),
    D.* EXCEPT (Account),
FROM objective_1_site AS A
LEFT JOIN objective_1_region AS B           ON A.Account = B.Account2
LEFT JOIN mse_social_emotional_edits AS C   ON A.Account = C.Account 
LEFT JOIN college_outcomes AS D             ON A.Account = D.Account   
LEFT JOIN college_graduates AS E            ON A.Account = E.Account    
)
SELECT 
    --CASE
   --         WHEN hr_financial_hs_capacity = 1 
    --        THEN CONCAT(Account,"_hr_finance_capacity")
   --         ELSE program.Account
    --        END AS Account,
    CASE
        WHEN program.Account = 'East Palo Alto' THEN 1
            WHEN program.Account = 'Oakland' THEN 2
            WHEN program.Account = 'San Francisco' THEN 3
            WHEN program.Account = 'New Orleans' THEN 4
            WHEN program.Account = 'Aurora' THEN 5
            WHEN program.Account = 'Boyle Heights' THEN 6
            WHEN program.Account = 'Sacramento' THEN 7
            WHEN program.Account = 'Watts' THEN 8
            WHEN program.Account = 'Denver' THEN 9
            WHEN program.Account = 'The Durant Center' THEN 10
            WHEN program.Account = 'Ward 8' THEN 11
            WHEN program.Account = 'Crenshaw' THEN 12
            END AS site_sort,
       mapRegionShort (program.Account) AS Region, --crease Region column based on Account site name
       program.*, --EXCEPT (Account),
       hr.* EXCEPT (Account)
FROM join_all AS program
left JOIN hr_financial_sustainability_hs_capacity AS hr ON program.Account=hr.Account
*/