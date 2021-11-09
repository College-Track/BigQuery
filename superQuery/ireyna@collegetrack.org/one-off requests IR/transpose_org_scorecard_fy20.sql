--Using FY21_eoy_combined_metrics table to consolidate org scorecard data
/* Added Column: fiscal_year
 ALTER TABLE `data-studio-260217.performance_mgt.org_scorecard_fy20`
  ADD COLUMN fiscal_year STRING;
*/

/*Populated new fiscal_year column with 'FY20'
  UPDATE
  `data-studio-260217.performance_mgt.org_scorecard_fy20` 
SET
  fiscal_year = "FY20"
WHERE 
    fiscal_year IS NULL
 */
  

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
            * EXCEPT (site_short, Account,Fundraising_Target,__Capacty),
            Fundraising_Target AS annual_fundraising_target,
            mapSite(Account) AS Account, --site_abbrev to site_short 
            CASE 
                WHEN account IS NOT NULL 
                THEN 6
                ELSE NULL
                END AS Objective
        FROM `org-scorecard-286421.aggregate_data.financial_sustainability_fy20`
        WHERE Account LIKE '%College Track%' -- only looking at values that are site_long

        UNION DISTINCT

        SELECT 
            * EXCEPT (Account,site_short,Fundraising_Target,__Capacty),
            __Capacty AS hs_capacity,
            mapRegion(Account) AS Account, --region abrev to region_short
            CASE 
                WHEN account IS NOT NULL 
                THEN 6
                ELSE NULL
                END AS Objective
        FROM `org-scorecard-286421.aggregate_data.financial_sustainability_fy20`
        WHERE Account NOT LIKE '%College Track%' --only looking at values that are region_abrev
)
SELECT *
FROM financial_sustainability);
--ALTER TABLE hr_financial_sustainability_hs_capacity ADD COLUMN Measure STRING;

SELECT * 
FROM
    (SELECT annual_fundraising_target,capacity_target FROM hr_financial_sustainability_hs_capacity)
UNPIVOT( (annual_fundraising_target,capacity_target) FOR Measure
        IN (Account,capacity_target)
    ) AS test
    

/*
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
    CASE 
        WHEN Account LIKE '%Region%' THEN Account
        ELSE NULL 
        END AS Region,
    CASE 
        WHEN Account NOT LIKE '%Region%' THEN Account
        ELSE NULL 
        END AS Site,
 
FROM join_all
);
SELECT * FROM hr_financial_sustainability_hs_capacity
;

--Create table based on temporary tables above, and query below
/*
CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.org_scorecard_fy20`
OPTIONS
    (
    description= "Compiled outcomes for fy20 org scorecard"
    )
 AS 
*/
/* 
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
    C.* EXCEPT (Account),
    D.* EXCEPT (Account),
    E.* EXCEPT (Account)
FROM objective_1_site AS A
LEFT JOIN objective_1_region AS B           ON A.Account = B.Account2
LEFT JOIN mse_social_emotional_edits AS C   ON A.Account = C.Account 
LEFT JOIN college_outcomes AS D             ON A.Account = D.Account   
LEFT JOIN college_graduates AS E            ON A.Account = E.Account    
),
add_region_site AS (
    SELECT
        *,
        CASE 
        WHEN Account LIKE '%Region%' THEN Account
        ELSE NULL 
        END AS Region,
    CASE 
        WHEN Account NOT LIKE '%Region%' THEN Account
        ELSE NULL 
        END AS Site,
    FROM join_all 
),

join_on_site AS(
SELECT 
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
       program.* EXCEPT (account), 
       hr.* EXCEPT (account,site,region)
FROM add_region_site AS program
LEFT JOIN hr_financial_sustainability_hs_capacity AS hr ON program.site=hr.site 
),

join_on_region AS(
    SELECT 
        program_hr.* EXCEPT (
                            Capacity_Target,	
                            __Capacty,	
                            __students,
                            Fundraising_Target,
                            ENGAGEMENT_SCORE,	
                            TENURE,
                            Non_white,	
                            LGBTQ,	
                            Male,
                            First_Gen
                            ),
      
        CASE WHEN hr.__students IS NOT NULL 
        THEN hr.__students
        ELSE program_hr.__students
        END AS __students,
        
        CASE WHEN hr.Capacity_Target IS NOT NULL 
        THEN hr.Capacity_Target
        ELSE program_hr.Capacity_Target
        END AS Capacity_Target,
        
        CASE WHEN hr.__Capacty IS NOT NULL 
        THEN hr.__Capacty
        ELSE program_hr.__Capacty
        END AS __Capacty,
        
        CASE WHEN hr.Fundraising_Target IS NOT NULL 
        THEN hr.Fundraising_Target
        ELSE program_hr.Fundraising_Target
        END AS Fundraising_Target,
        
        CASE WHEN hr.ENGAGEMENT_SCORE IS NOT NULL 
        THEN hr.ENGAGEMENT_SCORE
        ELSE program_hr.ENGAGEMENT_SCORE
        END AS ENGAGEMENT_SCORE,
        
        CASE WHEN hr.TENURE IS NOT NULL 
        THEN hr.TENURE
        ELSE program_hr.TENURE
        END AS TENURE,
        
        CASE WHEN hr.Non_white IS NOT NULL 
        THEN hr.Non_white
        ELSE program_hr.Non_white
        END AS Non_white,
        
        CASE WHEN hr.LGBTQ IS NOT NULL 
        THEN hr.LGBTQ
        ELSE program_hr.LGBTQ
        END AS LGBTQ,
        
        CASE WHEN hr.Male IS NOT NULL 
        THEN hr.Male
        ELSE program_hr.Male
        END AS Male,
        
        CASE WHEN hr.First_Gen IS NOT NULL 
        THEN hr.First_Gen
        ELSE program_hr.First_Gen
        END AS First_Gen,
        
    FROM join_on_site program_hr
    LEFT JOIN hr_financial_sustainability_hs_capacity AS hr 
        ON program_hr.region = hr.region
)
 SELECT *
 FROM join_on_region

*/