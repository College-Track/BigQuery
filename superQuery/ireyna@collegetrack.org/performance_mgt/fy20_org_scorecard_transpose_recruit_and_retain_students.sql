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
)--,
--join AS (
SELECT 
    DISTINCT
    A.* EXCEPT (National),
    B.* EXCEPT (Account)
FROM objective_1_site AS A
LEFT JOIN objective_1_region AS B  ON A.Account = B.Account2
