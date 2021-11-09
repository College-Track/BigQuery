/*
Measures include:  
% of entering 9th grade students who are low-income AND first-gen
% of entering 9th grade students who are male
% of high school students retained annually
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
CREATE TEMPORARY FUNCTION mapRegionAbrev (Account STRING) AS (
    CASE
        WHEN Account LIKE '%Northern California%' THEN 'NORCAL'
        WHEN Account LIKE '%Colorado%' THEN 'CO'
        WHEN Account LIKE '%Los Angeles%' THEN 'LA'
        WHEN Account LIKE '%New Orleans%' THEN 'NOLA'
        WHEN Account LIKE '%DC%' THEN 'DC'
        END
    )
        ;
CREATE TEMPORARY FUNCTION AccountAbrev (Account STRING) AS (
    CASE
        WHEN Account LIKE '%Northern California%' THEN 'NORCAL'
        WHEN Account LIKE '%Colorado%' THEN 'CO'
        WHEN Account LIKE '%Los Angeles%' THEN 'LA'
        WHEN Account LIKE '%New Orleans%' THEN 'NOLA_RG'
        WHEN Account LIKE '%DC%' THEN 'DC'
        WHEN Account LIKE '%Denver%' THEN 'DEN'
        WHEN Account LIKE '%Aurora%' THEN 'AUR'
        WHEN Account LIKE '%San Francisco%' THEN 'SF'
        WHEN Account LIKE '%East Palo Alto%' THEN 'EPA'
        WHEN Account LIKE '%Sacramento%' THEN 'SAC'
        WHEN Account LIKE '%Oakland%' THEN 'OAK'
        WHEN Account LIKE '%Watts%' THEN 'WATTS'
        WHEN Account LIKE '%Boyle Heights%' THEN 'BH'
        WHEN Account LIKE '%Ward 8%' THEN 'WARD8'
        WHEN Account LIKE '%Durant%' THEN 'PGC'
        WHEN Account LIKE '%New Orleans%' THEN 'NOLA'
        WHEN Account LIKE '%Crenshaw%' THEN 'CREN'
        WHEN Account = 'National' THEN 'NATIONAL'
        WHEN Account = 'National (AS LOCATION)' THEN 'NATIONAL_AS_LOCATION'
      END
    )
        ;
CREATE TEMP TABLE recruit_and_retain_site AS
    SELECT 
    * EXCEPT (Site__Account_Name,Region__Account_Name),
    CASE WHEN Site__Account_Name = 'NATIONAL' THEN 'National' ELSE mapSite(Site__Account_Name) END AS Account,
    FROM `org-scorecard-286421.aggregate_data.objective_1_site`
        ;
        
CREATE TEMP TABLE recruit_and_retain_region AS
    SELECT 
    * EXCEPT (Region),
    mapRegion(Region) AS Account
    FROM `org-scorecard-286421.aggregate_data.objective_1_region`
        ;

ALTER TABLE recruit_and_retain_site
    ADD COLUMN Measure STRING,
    ADD COLUMN Objective STRING,
    ADD COLUMN fiscal_year STRING;
UPDATE recruit_and_retain_site --Populate 'fiscal year' with 'FY20'
    SET fiscal_year = "FY20"
    WHERE fiscal_year IS NULL
        ;
INSERT INTO recruit_and_retain_site (Account) VALUES ('National')
        ;
ALTER TABLE recruit_and_retain_region
    ADD COLUMN Measure STRING,
    ADD COLUMN Objective STRING,
    ADD COLUMN fiscal_year STRING;
UPDATE recruit_and_retain_region --Populate 'fiscal year' with 'FY20'
    SET fiscal_year = "FY20"
    WHERE fiscal_year IS NULL
        ;

--Create table leveraging temporary table above
/*CREATE OR REPLACE TABLE `org-scorecard-286421.transposed_tables.admit_demographics_annual_retention_transposed`
OPTIONS
    (
    description="This is a transposed table for the objective: recruit and retain first-generation students from low-income communities . It only lists outcomes per region & site" 
    )
AS*/

--CTES: pivot each measure within the objective separately, then UNION        
WITH 

add_national_values_site AS(
    SELECT * EXCEPT (percent_male_fy20,percent_low_income_first_gen_fy20,percent_active_FY20),
        CASE WHEN Account = National  THEN SUM(sum_male)/SUM(denom_hs_admits) END AS percent_male_fy20, 
        CASE WHEN Account = National  THEN SUM(sum_low_income_first_gen)/SUM(denom_hs_admits) END AS percent_low_income_first_gen_fy20, 
        CASE WHEN Account = National  THEN SUM(sum_active_hs)/SUM(denom_annual_retention) END AS percent_active_FY20
    FROM recruit_and_retain_site 
    GROUP BY sum_male,sum_low_income_first_gen,sum_active_hs,denom_annual_retention,denom_hs_admits,account,Measure,objective,fiscal_year
),
site_pivot_male_site AS (
    SELECT *,--pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account)   AS Account, --transform Accounts to abbreviations to enable pivot 
            percent_male_fy20/100 AS male_admits_outcome,
            --percent_low_income_first_gen_fy20/100 AS low_income_first_gen_admits_outcome,
            --percent_active_FY20/100 AS annual_retention_outcome,
            CASE WHEN Measure IS NULL THEN 'entering_9th_grade_students_male' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_1' ELSE NULL END AS Objective,
            fiscal_year
        FROM add_national_values_site
        )
    PIVOT (MAX(male_admits_outcome) FOR Account --pivot outcomes as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','WARD8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION'))--pivot location as columns
    WHERE Measure = 'entering_9th_grade_students_male' --only transform data for 9th grade students that are male
    ),
    
site_pivot_low_income_first_gen_site AS (
    SELECT *, --pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account)   AS Account, --transform Accounts to abbreviations to enable pivot 
            --percent_male_fy20/100 AS male_admits_outcome,
            percent_low_income_first_gen_fy20/100 AS low_income_first_gen_admits_outcome,
            --percent_active_FY20/100 AS annual_retention_outcome,
            CASE WHEN Measure IS NULL THEN 'entering_9th_grade_students_lowincome_firstgen' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_1' ELSE NULL END AS Objective,
            fiscal_year
        FROM add_national_values_site
        )
    PIVOT (MAX(low_income_first_gen_admits_outcome) FOR Account --pivot outcome values as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','WARD8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION')) --pivot location as columns
    WHERE Measure = 'entering_9th_grade_students_lowincome_firstgen' --only transform data for measure: 9th grade students first gen, low income
),

annual_retention_pivot_site AS (
    SELECT *,--pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account)   AS Account, --transform Accounts to abbreviations to enable pivot 
            --percent_male_fy20/100 AS male_admits_outcome,
            --percent_low_income_first_gen_fy20/100 AS low_income_first_gen_admits_outcome,
            percent_active_FY20/100 AS annual_retention_outcome,
            CASE WHEN Measure IS NULL THEN 'annual_retention' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_1' ELSE NULL END AS Objective,
            fiscal_year
        FROM add_national_values_site
        )
    PIVOT (MAX(annual_retention_outcome) FOR Account --pivot outcome values as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','WARD8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION')) --pivot location as columns
    WHERE Measure = 'annual_retention' --only transform data for annual_retention_outcome
),
add_national_values_region AS(
    SELECT * EXCEPT (percent_male_fy20,percent_low_income_first_gen_fy20,percent_active_FY20),
        CASE WHEN Account = 'National' AND percent_male_fy20 IS NULL THEN SUM(sum_male)/SUM(denom_hs_admits) ELSE percent_male_fy20 END AS percent_male_fy20, 
        CASE WHEN Account = 'National' AND percent_low_income_first_gen_fy20 IS NULL THEN SUM(sum_low_income_first_gen)/SUM(denom_hs_admits) ELSE percent_low_income_first_gen_fy20 END AS percent_low_income_first_gen_fy20, 
        CASE WHEN Account = 'National' AND percent_active_FY20 IS NULL THEN SUM(sum_active_hs)/SUM(denom_annual_retention) ELSE percent_active_FY20 END AS percent_active_FY20
    FROM recruit_and_retain_region
    GROUP BY  sum_male,sum_low_income_first_gen,sum_active_hs,denom_annual_retention,denom_hs_admits,account,national,Measure,objective,fiscal_year,percent_male_fy20,percent_low_income_first_gen_fy20,percent_active_FY20
),
site_pivot_male_region AS (
    SELECT *,--pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account)   AS Account, --transform Accounts to abbreviations to enable pivot 
            percent_male_fy20/100 AS male_admits_outcome,
            --percent_low_income_first_gen_fy20/100 AS low_income_first_gen_admits_outcome,
            --percent_active_FY20/100 AS annual_retention_outcome,
            CASE WHEN Measure IS NULL THEN 'entering_9th_grade_students_male' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_1' ELSE NULL END AS Objective,
            fiscal_year
        FROM add_national_values_region
        )
    PIVOT (MAX(male_admits_outcome) FOR Account --pivot outcomes as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','WARD8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION'))--pivot location as columns
    WHERE Measure = 'entering_9th_grade_students_male' --only transform data for 9th grade students that are male
    ),
site_pivot_low_income_first_gen_region AS (
    SELECT *, --pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account)   AS Account, --transform Accounts to abbreviations to enable pivot 

            --percent_male_fy20/100 AS male_admits_outcome,
            percent_low_income_first_gen_fy20/100 AS low_income_first_gen_admits_outcome,
            --percent_active_FY20/100 AS annual_retention_outcome,
            CASE WHEN Measure IS NULL THEN 'entering_9th_grade_students_lowincome_firstgen' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_1' ELSE NULL END AS Objective,
            fiscal_year
        FROM add_national_values_region
        )
    PIVOT (MAX(low_income_first_gen_admits_outcome) FOR Account --pivot outcome values as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','WARD8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION')) --pivot location as columns
    WHERE Measure = 'entering_9th_grade_students_lowincome_firstgen' --only transform data for measure: 9th grade students first gen, low income
),

annual_retention_pivot_region AS (
    SELECT *,--pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account)   AS Account, --transform Accounts to abbreviations to enable pivot 
            --percent_male_fy20/100 AS male_admits_outcome,
            --percent_low_income_first_gen_fy20/100 AS low_income_first_gen_admits_outcome,
            percent_active_FY20/100 AS annual_retention_outcome,
            CASE WHEN Measure IS NULL THEN 'annual_retention' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_1' ELSE NULL END AS Objective,
            fiscal_year
        FROM add_national_values_region
        )
    PIVOT (MAX(annual_retention_outcome) FOR Account --pivot outcome values as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','WARD8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION')) --pivot location as columns
    WHERE Measure = 'annual_retention' --only transform data for annual_retention_outcome
),
union_site_table AS(
SELECT *
UNION DISTINCT 
SELECT *
UNION DISTINCT
SELECT *
),
union_region_table AS(
SELECT * FROM site_pivot_male_region
UNION DISTINCT 
SELECT * FROM site_pivot_low_income_first_gen_region
UNION DISTINCT
SELECT * FROM annual_retention_pivot_region
)
SELECT 
site.* EXCEPT (DC,CO,LA,NOLA_RG,NORCAL,NATIONAL,NATIONAL_AS_LOCATION), 
region.DC, region.CO, region.LA, region.NOLA_RG, region.NORCAL, region.NATIONAL, region.NATIONAL_AS_LOCATION
FROM union_site_table AS site
LEFT JOIN union_region_table AS region ON site.measure=region.measure