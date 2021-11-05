--Using FY21_eoy_combined_metrics table to consolidate org scorecard data
/*
    

    Strategy Team representing a spectrum of identities above average nonprofit benchmarks*
    Annual Fundraising target (100%)
    Staff with full-time tenure of 3+ years in organization (35%)
  
    Staff engagement score above average nonprofit benchmark (Y)
*/

#UNION TESTS



CREATE TEMPORARY FUNCTION mapSite (site STRING) AS ( --Remap abbreviated site names to site_short
   CASE 
            WHEN site = 'College Track East Palo Alto' THEN 'East Palo Alto'
            WHEN site = 'College Track Oakland' THEN 'Oakland'
            WHEN site = 'College Track San Francisco' THEN 'San Francisco'
            WHEN site = 'College Track New Orleans' THEN 'New Orleans'
            WHEN site = 'College Track Aurora' THEN 'Aurora'
            WHEN site = 'College Track Boyle Heights' THEN 'Boyle Heights'
            WHEN site = 'College Track Sacramento' THEN 'Sacramento'
            WHEN site = 'College Track Watts' THEN 'Watts'
            WHEN site = 'College Track Denver' THEN 'Denver'
            WHEN site = 'College Track at The Durant Center' THEN 'The Durant Center'
            WHEN site = 'College Track Ward 8' THEN 'Ward 8'
            WHEN site = 'College Track Crenshaw' THEN 'Crenshaw'
            WHEN site = 'EPA' THEN 'East Palo Alto'
            WHEN site = 'OAK' THEN 'Oakland'
            WHEN site = 'SF' THEN 'San Francisco'
            WHEN site = 'NOLA' THEN 'New Orleans'
            WHEN site = 'AUR' THEN 'Aurora'
            WHEN site = 'BH' THEN 'Boyle Heights'
            WHEN site = 'SAC' THEN 'Sacramento'
            WHEN site = 'WATTS' THEN 'Watts'
            WHEN site = 'DEN' THEN 'Denver'
            WHEN site = 'PGC' THEN 'The Durant Center'
            WHEN site = 'DC8' THEN 'Ward 8'
            WHEN site = 'CREN' THEN 'Crenshaw'
            WHEN site = 'NATIONAL' THEN 'National'
            WHEN site = 'National' THEN 'National'
            WHEN site = 'NATIONAL (AS LOCATION)'THEN 'National (As Location)'
       END)
       ;
CREATE TEMPORARY FUNCTION mapRegion(site STRING) AS ( --map Region based on Site, remap region abbreviations to region_short
    CASE 
            WHEN site = 'College Track Northern California Region' THEN 'Northern California Region'
            WHEN site = 'College Track New Orleans Region' THEN 'New Orleans Region'
            WHEN site = 'College Track Colorado Region' THEN 'Colorado Region'
            WHEN site = 'College Track Los Angeles Region' THEN 'Los Angeles Region'
            WHEN site = 'College Track DC Region' THEN 'DC Region'
            WHEN site = 'EPA' THEN 'Northern California Region'
            WHEN site = 'OAK' THEN 'Northern California Region'
            WHEN site = 'SF' THEN 'Northern California Region'
            WHEN site = 'NOLA' THEN 'New Orleans Region'
            WHEN site = 'AUR' THEN 'Colorado Region'
            WHEN site = 'BH' THEN 'Los Angeles Region'
            WHEN site = 'SAC' THEN 'Northern California Region'
            WHEN site = 'WATTS' THEN 'Los Angeles Region'
            WHEN site = 'DEN' THEN 'Colorado Region'
            WHEN site = 'PGC' THEN 'DC Region'
            WHEN site = 'DC8' THEN 'DC Region'
            WHEN site = 'CREN' THEN 'Los Angeles Region'
            WHEN site = 'NATIONAL' THEN 'National'
            WHEN site = 'National' THEN 'National'
            WHEN site = 'NATIONAL (AS LOCATION)' THEN 'National (As Location)'
            WHEN site = 'NORCAL' THEN 'Northern California Region'
            WHEN site = 'LA' THEN 'Los Angeles Region'
            WHEN site = 'CO' THEN 'Colorado Region'
            WHEN site = 'NOLA' THEN 'New Orleans Region'
            WHEN site = 'DC' THEN 'DC Region'
            WHEN site = 'College Track East Palo Alto' THEN 'Northern California Region'
            WHEN site = 'College Track Oakland' THEN 'Northern California Region'
            WHEN site = 'College Track San Francisco' THEN 'Northern California Region'
            WHEN site = 'College Track New Orleans' THEN 'New Orleans Region'
            WHEN site = 'College Track Aurora' THEN 'Colorado Region'
            WHEN site = 'College Track Boyle Heights' THEN 'Los Angeles Region'
            WHEN site = 'College Track Sacramento' THEN 'Northern California Region'
            WHEN site = 'College Track Watts' THEN 'Los Angeles Region'
            WHEN site = 'College Track Denver' THEN 'Colorado Region'
            WHEN site = 'College Track at The Durant Center' THEN 'DC Region'
            WHEN site = 'College Track Ward 8' THEN 'DC Region'
            WHEN site = 'College Track Crenshaw' THEN 'Los Angeles Region'
            
            
            
        END)        
        ;
WITH 

objective_1_site AS (
    SELECT 
        * EXCEPT (Site__Account_Name,Region__Account_Name),
        mapRegion(Region__Account_Name) AS Account1,
         CASE WHEN Region__Account_Name = 'NATIONAL' THEN 'National' ELSE Region__Account_Name END AS region_and_site
        
        FROM `org-scorecard-286421.aggregate_data.objective_1_site`
        GROUP BY National,sum_active_hs,sum_active_hs,sum_low_income_first_gen,sum_male,denom_hs_admits,percent_male_fy20,percent_low_income_first_gen_fy20,denom_annual_retention,percent_active_FY20,Region__Account_Name
        
        UNION DISTINCT

     SELECT 
        * EXCEPT (Site__Account_Name,Region__Account_Name),
        mapSite(Site__Account_Name) AS Account1,
        CASE WHEN Site__Account_Name = 'NATIONAL' THEN 'National' ELSE Site__Account_Name END AS region_and_site

        FROM `org-scorecard-286421.aggregate_data.objective_1_site`  
        GROUP BY National,sum_active_hs,sum_active_hs,sum_low_income_first_gen,sum_male,denom_hs_admits,percent_male_fy20,percent_low_income_first_gen_fy20,denom_annual_retention,percent_active_FY20,Site__Account_Name
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

hr_tenure AS ( 
    SELECT 
        * EXCEPT (site,region), site as Account
        --mapRegion(site)    AS Account  --Map Region based on Site using mapRegion func,mapping site names and 
        FROM`org-scorecard-286421.aggregate_data.HR_outcomes_tenure_engagement`
        GROUP BY Account,ENGAGEMENT_SCORE,TENURE
    
    UNION ALL

    SELECT 
        * EXCEPT (site,region),
        --mapRegion(region)  AS Account, --remap region abbreviations to region_short
        CASE WHEN region = 'NATIONAL' THEN 'National' WHEN region = 'NATIONAL (AS LOCATION)' THEN 'National (As Location)' ELSE region END AS Account
        FROM`org-scorecard-286421.aggregate_data.HR_outcomes_tenure_engagement`
        GROUP BY Account,ENGAGEMENT_SCORE,TENURE
),

hr_identities AS (
    SELECT 
        * EXCEPT (Account,string_field_5),
        mapRegion(Account)  AS Account --mapping site names and region abbreviations to region_short
        FROM`org-scorecard-286421.aggregate_data.HR_outcomes_identity`
        GROUP BY Account,Non_white,LGBTQ,Male,First_Gen
),

join_all AS (
SELECT 
    DISTINCT
    mapSite(Account1) AS site,
    mapRegion(Account1) AS region,
    A.* EXCEPT (National),
    C.* EXCEPT (Account),
    D.* EXCEPT (Account),
    E.* EXCEPT (Account),
    F.* EXCEPT (Account),
    G.* EXCEPT (Account),
    H.* EXCEPT (Account)
FROM objective_1_site AS A
LEFT JOIN objective_1_region AS B           ON A.Account1 = B.Account2
FULL JOIN financial_sustainability AS C     ON A.Account1 = C.Account 
FULL JOIN mse_social_emotional_edits AS F   ON A.Account1 = F.Account   --AND A.site_short = F.Account    --AND B.region_short = F.region_short
FULL JOIN hr_tenure AS G                    ON A.Account1 = G.Account    -- AND A.region_short = G.Account  
FULL JOIN hr_identities AS H                ON A.Account1 = H.Account 
FULL JOIN college_outcomes AS D             ON A.Account1 = D.Account   --AND A.site_short = D.Account 
FULL JOIN college_graduates AS E            ON A.Account1 = E.Account   --AND A.site_short = E.Account -- AND A.region_short = E.region_only   

--WHERE Account1 IS NOT NULL 

GROUP BY 
Account1,
sum_male,
sum_low_income_first_gen,
denom_hs_admits,
percent_male_fy20,
percent_low_income_first_gen_fy20,
sum_active_hs,
denom_annual_retention,
percent_active_FY20,
__students,
Capacity_Target,
__Capacty,
Fundraising_Target,
on_track,
Matriculate_to_Best__Good__or_Situational,
_6_yr_grad_rate,
gainful_employment_standard,
full_time_employment_or_grad_school_6_months,
meaningful_employment,
Meaningful_Summer_Experiences,
CoVi_growth,
GPA___Composite,
ENGAGEMENT_SCORE,
TENURE,
Non_white,
LGBTQ,
Male,
First_Gen,
REGION_AND_SITE
)


SELECT *,
     CASE
            WHEN site = 'East Palo Alto' THEN 1
            WHEN site = 'Oakland' THEN 2
            WHEN site = 'San Francisco' THEN 3
            WHEN site = 'New Orleans' THEN 4
            WHEN site = 'Aurora' THEN 5
            WHEN site = 'Boyle Heights' THEN 6
            WHEN site = 'Sacramento' THEN 7
            WHEN site = 'Watts' THEN 8
            WHEN site = 'Denver' THEN 9
            WHEN site = 'The Durant Center' THEN 10
            WHEN site = 'Ward 8' THEN 11
            WHEN site = 'Crenshaw' THEN 12
            END AS site_sort,
FROM join_all
WHERE site IS NOT NULL 