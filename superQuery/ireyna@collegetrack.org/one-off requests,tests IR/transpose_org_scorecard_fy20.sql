

WITH
unpivot AS (
    SELECT 
        * 
    FROM
        (
        SELECT 
            Account,
            Capacity_Target,
            __Capacty AS hs_capacity_outcome,
            Fundraising_Target AS fundraising_target_outcome,
            CASE 
            WHEN __students IS NOT NULL 
            THEN __students
            ELSE NULL
            END AS numerator
        FROM hr_financial_sustainability_hs_capacity
        )
        PIVOT 
        (Max(NUMERATOR) FOR Account
       IN ('DC Region','Colorado Region','Los Angeles Region','New Orleans Region','Northern California Region'))
     
    /*UNPIVOT INCLUDE NULLS  
        (Outcome FOR Measure IN (hs_capacity_outcome,fundraising_target_outcome) --Create a "Measure" column 
        ) AS UNPVt,*/
    /*PIVOT (Max(numerator) FOR Account
       IN (
       
       "DC Region",'Colorado Region','Los Angeles Region','New Orleans Region','Northern California Region',
        'East Palo Alto',
        'Oakland',
        'San Francisco',
        'New Orleans',
        'Aurora',
        'Boyle Heights',
        'Sacramento',
        'Watts',
        'Denver',
        'The Durant Center',
        'Ward 8',
        'National')
        ) AS pivot
        )
 
      

 
/*
--This works for 2 transformations
SELECT * 
FROM 
(SELECT  __Capacty, Fundraising_Target
FROM hr_financial_sustainability_hs_capacity )
    UNPIVOT INCLUDE NULLS  (
    Outcome FOR Measure in (__Capacty,Fundraising_Target) 
) AS UNPVT

SELECT `Account`,
  SPLIT(kv, ':')[OFFSET(0)] Measure,
  SPLIT(kv, ':')[OFFSET(1)] Outcome,
  SPLIT(kv, ':')[SAFE_OFFSET(2)] Values
FROM hr_financial_sustainability_hs_capacity t,
UNNEST(SPLIT(REGEXP_REPLACE(TO_JSON_STRING(t), r'[{}"]', ''))) kv
WHERE SPLIT(kv, ':')[OFFSET(0)] != 'Account'
AND SPLIT(kv, ':')[OFFSET(0)] NOT IN ('__students','Capacity_Target')
AND SPLIT(kv, ':')[OFFSET(2)] IN ('__students','Capacity_Target')


SELECT * 
FROM
    (SELECT Fundraising_Target,__Capacty FROM hr_financial_sustainability_hs_capacity)
UNPIVOT INCLUDE NULLS 
        (Fundraising_Target FOR Measure
        IN (Outcome)
        
SELECT Account, __Capacty, Fundraising_Target
FROM hr_financial_sustainability_hs_capacity 
UNPIVOT INCLUDE NULLS  (Outcome FOR Accounts in (  __Capacty, Fundraising_Target) ) AS UNPVT

*/    
     
     /* 
  multi_column_unpivot:
    values_column_set
    FOR name_new_column
    IN (new_column_Names_sets_to_unpivot)

*/
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