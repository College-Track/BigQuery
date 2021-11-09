--tranforming table orientation of financial susainability table

    SELECT
        CASE 
        WHEN sum_male IS NOT NULL THEN sum_male
        WHEN sum_male IS NOT NULL THEN sum_male
        WHEN sum_male IS NOT NULL THEN sum_male
        WHEN sum_male IS NOT NULL THEN sum_male
        WHEN sum_male IS NOT NULL THEN sum_male
        WHEN 
sum_low_income_first_gen
denom_hs_admits
percent_male_fy20
percent_low_income_first_gen_fy20
sum_active_hs
denom_annual_retention
percent_active_FY20
Meaningful_Summer_Experiences
CoVi_growth
GPA___Composite
Matriculate_to_Best__Good__or_Situational
on_track
_6_yr_grad_rate
full_time_employment_or_grad_school_6_months
gainful_employment_standard
meaningful_employment
__students
Capacity_Target
__Capacty
Fundraising_Target
ENGAGEMENT_SCORE
TENURE
Non_white
LGBTQ
Male
First_Gen
    FROM  `data-studio-260217.performance_mgt.org_scorecard_fy20`
/*
WITH
unpivot AS (
    SELECT 
        * 
    FROM
        (
        SELECT 
        distinct
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
        (Outcome FOR Measure IN (fundraising_target_outcome), IN (hs_capacity_outcome)) --Create a "Measure" column 
        ) AS UNPVt
   */