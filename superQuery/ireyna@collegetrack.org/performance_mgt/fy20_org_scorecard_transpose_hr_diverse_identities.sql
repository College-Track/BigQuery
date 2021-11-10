/*
Measures include:  
% of strategy team representing a spectrum of identities above average nonprofit benchmarks (race, ethnicity, gender, age, LGBTQ, etc.) 
    % First Gen
    % Person of color
    % LGBTQ
    % Male
    
    Our staff represent a diverse, high-performing, and engaged community
*/


CREATE TEMP TABLE hr_diverse_identities AS (--create temp table to create Objective, Measure, and fiscal_year columns 

        SELECT 
        * EXCEPT (string_field_5)
        FROM`org-scorecard-286421.aggregate_data.HR_outcomes_identity`
        WHERE Account IS NOT NULL
    )
    ;
ALTER TABLE hr_diverse_identities
    ADD COLUMN Measure STRING,
    ADD COLUMN Objective STRING,
    ADD COLUMN fiscal_year STRING;
UPDATE hr_diverse_identities --Populate 'fiscal year' with 'FY20'
    SET fiscal_year = "FY20"
    WHERE fiscal_year IS NULL
    ;
    
WITH 

LGBTQ_pivot AS(
    SELECT * --pivot table to make regions and sites columns instead of row
    FROM
        (
        SELECT 
            Account,
            LGBTQ AS percent_LGBTQ_fy20,
            CASE WHEN Measure IS NULL THEN 'lgbtq' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_5' ELSE NULL END AS Objective,
            fiscal_year
        FROM hr_diverse_identities
        )
    PIVOT (MAX(percent_LGBTQ_fy20) FOR Account
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','WARD8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION'))
    WHERE Measure = 'lgbtq' --only transform annual fundraising outcomes
),

non_white_pviot AS(
    SELECT * --pivot table to make regions and sites columns instead of row
    FROM
        (
        SELECT 
            Account,
            non_white AS percent_non_white_fy20,
            CASE WHEN Measure IS NULL THEN 'non_white' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_5' ELSE NULL END AS Objective,
            fiscal_year
        FROM hr_diverse_identities
        )
    PIVOT (MAX(percent_non_white_fy20) FOR Account
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','WARD8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION'))
    WHERE Measure = 'non_white' --only transform annual fundraising outcomes
),

male_pivot AS(
    SELECT * --pivot table to make regions and sites columns instead of row
    FROM
        (
        SELECT 
            Account,
            male AS percent_male_hr_fy20,
            CASE WHEN Measure IS NULL THEN 'male' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_5' ELSE NULL END AS Objective,
            fiscal_year
        FROM hr_diverse_identities
        )
    PIVOT (MAX(percent_male_hr_fy20) FOR Account
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','WARD8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION'))
    WHERE Measure = 'male' --only transform annual fundraising outcomes
),

first_gen_pivot AS(
    SELECT * --pivot table to make regions and sites columns instead of row
    FROM
        (
        SELECT 
            Account,
            first_gen AS percent_first_gen_hr_fy20,
            CASE WHEN Measure IS NULL THEN 'first_gen' ELSE NULL END AS Measure, --populate 'Measure' column with annual_fundraising to isolate measure
            CASE WHEN Objective IS NULL THEN 'Objective_5' ELSE NULL END AS Objective,
            fiscal_year
        FROM hr_diverse_identities
        )
    PIVOT (MAX(percent_first_gen_hr_fy20) FOR Account
       IN ('EPA','OAK','SF','NOLA','AUR','BH','SAC','WATTS','DEN','PGC','WARD8','CREN','DC','CO','LA','NOLA_RG','NORCAL','NATIONAL','NATIONAL_AS_LOCATION'))
    WHERE Measure = 'first_gen' --only transform annual fundraising outcomes
)
SELECT *
FROM LGBTQ_pivot 

UNION DISTINCT 

SELECT *
FROM non_white_pviot 

UNION DISTINCT 

SELECT *
FROM male_pivot 

UNION DISTINCT 

SELECT *
FROM first_gen_pivot 