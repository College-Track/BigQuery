# `data-warehouse-289815.performance_mgt.fy20_impact_framework_wide` table is based off of the 19/20 Source Data: https://docs.google.com/spreadsheets/d/1Yck68wJxUO6usCx1UvjKyEYIrZvl38OMVR9ghNdQ82E/edit?usp=sharing
# The fy20_impact_framework_wide table is actually built from a trimmed version of the above: https://docs.google.com/spreadsheets/d/1XtgByrDYWb4ILEgrGKbiaH0KCgIDuoDqMjfZ96pyrGw/edit?usp=sharing


--Create fy20_impact_framework_long
/*
CREATE OR REPLACE TABLE `data-warehouse-289815.performance_mgt.fy20_impact_framework_long`
OPTIONS
    (
    description=
    "This table is a transposed version of data-warehouse-289815.performance_mgt.fy20_impact_framework_wide.  Stores numerator, denominator and outcome of each measure for FY20. Based on 19/20 Source Data tab in the IF. This table is a transposed version of: https://docs.google.com/spreadsheets/d/1XtgByrDYWb4ILEgrGKbiaH0KCgIDuoDqMjfZ96pyrGw/edit?usp=sharing "
    )
    AS 
*/
WITH

unpivot_table AS (
    SELECT * 
     FROM `data-warehouse-289815.performance_mgt.fy20_impact_framework_wide` 

    UNPIVOT INCLUDE NULLS  
        (Outcome FOR site_or_region IN (EPA,OAK,SF,NOLA,AUR,BH,SAC,WATTS,DEN,PGC,DC8,National,Northern_California,Bay_Area,Colorado,Los_Angeles,DC) --Create a "site_or_region" column 
        ) AS unpivot_if_table
    )
    SELECT * FROM unpivot_table