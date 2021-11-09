--tranforming table orientation of financial susainability table

WITH
unpivot AS (
    SELECT 
        * 
    FROM
        (
        SELECT 
            Capacity_Target,
            __Capacty AS hs_capacity_outcome,
            Fundraising_Target AS fundraising_target_outcome,
            CASE 
                WHEN __students IS NOT NULL 
                THEN __students
                ELSE NULL
                END AS numerator,
             CASE
                WHEN region LIKE '%Northern California%' THEN 'NOR_CAL'
                WHEN region LIKE '%Colorado%' THEN 'CO'
                WHEN region LIKE '%Los Angeles%' THEN 'LA'
                WHEN region LIKE '%New Orleans%' THEN 'NOLA'
                WHEN region LIKE '%DC%' THEN 'DC'
                ELSE region
                END AS region_abrev,
        FROM  `data-studio-260217.performance_mgt.org_scorecard_fy20`
        )
    PIVOT (Max(numerator) FOR region_abrev
       IN ('NORCAL','CO','LA','NOLA','DC')
        )
        )
    SELECT 
        * 
    FROM unpivot
    UNPIVOT 
        (Outcome FOR Measure IN (hs_capacity_outcome,fundraising_target_outcome) --Create a "Measure" column 
        ) AS UNPVt
   