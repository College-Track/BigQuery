/*
Measures include:  
% of seniors with GPA 3.25+ AND Composite Ready 
% of students with meaningful summer experiences
% of students growing toward average or above social-emotional strengths 
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
        WHEN Account LIKE '%New Orleans Region%' THEN 'NOLA_RG'
        WHEN Account LIKE '%DC%' THEN 'DC'
        WHEN Account LIKE '%Denver%' THEN 'DEN'
        WHEN Account LIKE '%Aurora%' THEN 'AUR'
        WHEN Account LIKE '%San Francisco%' THEN 'SF'
        WHEN Account LIKE '%East Palo Alto%' THEN 'EPA'
        WHEN Account LIKE '%Sacramento%' THEN 'SAC'
        WHEN Account LIKE '%Oakland%' THEN 'OAK'
        WHEN Account LIKE '%Watts%' THEN 'WATTS'
        WHEN Account LIKE '%Boyle Heights%' THEN 'BH'
        WHEN Account LIKE '%Ward 8%' THEN 'DC8'
        WHEN Account LIKE '%Durant%' THEN 'PGC'
        WHEN Account LIKE '%New Orleans%' THEN 'NOLA'
        WHEN Account LIKE '%Crenshaw%' THEN 'CREN'
        WHEN Account = 'National' THEN 'NATIONAL'
        WHEN Account = 'National (AS LOCATION)' THEN 'NATIONAL_AS_LOCATION'
      END
    )
        ;
CREATE TEMP TABLE mse_social_emotional_gpa_composite_site AS
   SELECT
        * EXCEPT (site_short, Account),
            mapSite(Account) AS Account, --site_abbrev to site_short 
    FROM `org-scorecard-286421.aggregate_data.HS_MSE_CoVi_FY20`
    WHERE Account LIKE '%College Track%' -- only looking at values that are site_long
        ;
        
CREATE TEMP TABLE mse_social_emotional_gpa_composite_region AS
    SELECT 
        * EXCEPT (Account,site_short),
        mapRegion(Account) AS Account --region abrev to region_short
    FROM  `org-scorecard-286421.aggregate_data.HS_MSE_CoVi_FY20`
    WHERE Account NOT LIKE '%College Track%' --only looking at values that are region_abrev
        ;

ALTER TABLE mse_social_emotional_gpa_composite_site
    ADD COLUMN Measure STRING,
    ADD COLUMN Objective STRING,
    ADD COLUMN fiscal_year STRING;
UPDATE mse_social_emotional_gpa_composite_site --Populate 'fiscal year' with 'FY20'
    SET fiscal_year = "FY20"
    WHERE fiscal_year IS NULL
        ;
ALTER TABLE mse_social_emotional_gpa_composite_region
    ADD COLUMN Measure STRING,
    ADD COLUMN Objective STRING,
    ADD COLUMN fiscal_year STRING;
UPDATE mse_social_emotional_gpa_composite_region --Populate 'fiscal year' with 'FY20'
    SET fiscal_year = "FY20"
    WHERE fiscal_year IS NULL
        ;
--Create table leveraging temporary table above
CREATE OR REPLACE TABLE `org-scorecard-286421.transposed_tables.mse_covi_gpa_composite`
OPTIONS
    (
    description="This is a transposed table for the objective: students have a strong academic and social-emotional foundation. It only lists outcomes per region & site" 
    )
AS

--CTES: pivot each measure within the objective separately, then UNION        
WITH 

mses_pivot_site AS (
    SELECT *,--pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account) AS Account,
            meaningful_summer_experiences AS percent_mse_fy20,
            CASE WHEN Measure IS NULL THEN 'mse' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_2' ELSE NULL END AS Objective,
            fiscal_year
        FROM mse_social_emotional_gpa_composite_site
        )
    PIVOT (MAX(percent_mse_fy20) FOR Account --pivot outcomes as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','DC8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION'))--pivot location as columns
    WHERE Measure = 'mse' --only transform data for 9th grade students that are male
    ),
    
social_emotional_growth_pivot_site AS (
    SELECT *, --pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account) AS Account,
            CoVi_growth AS percent_social_emotional_growth_fy20,
            CASE WHEN Measure IS NULL THEN 'social_emotional_growth' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_2' ELSE NULL END AS Objective,
            fiscal_year
        FROM mse_social_emotional_gpa_composite_site
        )
    PIVOT (MAX(percent_social_emotional_growth_fy20) FOR Account --pivot outcome values as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','DC8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION')) --pivot location as columns
    WHERE Measure = 'social_emotional_growth' --only transform data for measure: 9th grade students first gen, low income
),

gpa_3_0_composite_ready_pivot_site AS (
    SELECT *,--pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account) AS Account,
            GPA___Composite AS percent_gpa_composite_fy20,
            CASE WHEN Measure IS NULL THEN 'gpa_3_0_composite_readiness' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_2' ELSE NULL END AS Objective,
            fiscal_year
        FROM mse_social_emotional_gpa_composite_site
        )
    PIVOT (MAX(percent_gpa_composite_fy20) FOR Account --pivot outcome values as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','DC8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION')) --pivot location as columns
    WHERE Measure = 'gpa_3_0_composite_readiness' --only transform data for annual_retention_outcome
),
mses_pivot_site_region AS (
    SELECT *,--pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account) AS Account,
            meaningful_summer_experiences AS percent_mse_fy20,
            CASE WHEN Measure IS NULL THEN 'mse' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_2' ELSE NULL END AS Objective,
            fiscal_year
        FROM mse_social_emotional_gpa_composite_region
        )
    PIVOT (MAX(percent_mse_fy20) FOR Account --pivot outcomes as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','DC8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION'))--pivot location as columns
    WHERE Measure = 'mse' --only transform data for 9th grade students that are male
    ),
    
social_emotional_growth_pivot_region AS (
    SELECT *, --pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account) AS Account,
            covi_growth AS percent_social_emotional_growth_fy20,
            CASE WHEN Measure IS NULL THEN 'social_emotional_growth' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_2' ELSE NULL END AS Objective,
            fiscal_year
        FROM mse_social_emotional_gpa_composite_region
        )
    PIVOT (MAX(percent_social_emotional_growth_fy20) FOR Account --pivot outcome values as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','DC8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION')) --pivot location as columns
    WHERE Measure = 'social_emotional_growth' --only transform data for measure: 9th grade students first gen, low income
),

gpa_3_0_composite_ready_pivot_region AS (
    SELECT *,--pivot table to make regions and sites columns instead of rows
    FROM
        (
        SELECT 
            AccountAbrev(Account) AS Account,
            GPA___Composite AS percent_gpa_composite_fy20,
            CASE WHEN Measure IS NULL THEN 'gpa_3_0_composite_readiness' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_2' ELSE NULL END AS Objective,
            fiscal_year
        FROM mse_social_emotional_gpa_composite_region
        )
    PIVOT (MAX(percent_gpa_composite_fy20) FOR Account --pivot outcome values as row values
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','DC8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION')) --pivot location as columns
    WHERE Measure = 'gpa_3_0_composite_readiness' --only transform data for annual_retention_outcome
),
union_site_table AS(
SELECT * FROM mses_pivot_site
UNION DISTINCT 
SELECT * FROM social_emotional_growth_pivot_site
UNION DISTINCT
SELECT * FROM gpa_3_0_composite_ready_pivot_site
),
union_region_table AS(
SELECT * FROM mses_pivot_site_region
UNION DISTINCT 
SELECT * FROM social_emotional_growth_pivot_region
UNION DISTINCT
SELECT * FROM gpa_3_0_composite_ready_pivot_region
)
SELECT 
DISTINCT
site.* EXCEPT (DC,CO,LA,NOLA_RG,NORCAL,NATIONAL,NATIONAL_AS_LOCATION), 
region.DC, region.CO, region.LA, region.NOLA_RG, region.NORCAL, region.NATIONAL, region.NATIONAL_AS_LOCATION,

FROM union_site_table AS site
LEFT JOIN union_region_table AS region ON site.measure=region.measure 