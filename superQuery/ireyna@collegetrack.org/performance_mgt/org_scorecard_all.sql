--Combine Org Scorecard outcomes for FY20-current year, unpivoted

/*
CREATE OR REPLACE TABLE `org-scorecard-286421.aggregate_data.org_scorecard_outcomes`
OPTIONS
    (
    description="This table pulls Org Scorecard outcomes, numerators (where applicable), denominator (where applicable)" 
    )
    AS 
*/

WITH

unpivot_table AS (
    SELECT * 

     
     FROM `org-scorecard-286421.transposed_tables.org_scorecard_overview_all_fy`

    UNPIVOT INCLUDE NULLS  
        (Outcome FOR site_or_region IN (EPA,OAK,SF,AUR,BH,SAC,WATTS,DEN,PGC,DC8,CREN,DC,CO,LA,NOLA_RG,NOLA,NORCAL,NATIONAL,NATIONAL_AS_LOCATION) --Create a "site_or_region" column 
        ) AS UNPVt
    )
    SELECT * FROM unpivot_table