   
    WHEN measure_component IN  ('male_numerator','ninth_grade_denominator') THEN 
        * EXCEPT (percent_active_FY20,percent_male_fy20,percent_low_income_first_gen_fy20),
        CASE WHEN Account = 'NATIONAL' THEN sum_male/denom_hs_admits ELSE percent_male_fy20/100 END AS percent_male_fy20,
        CASE WHEN Account = 'NATIONAL' THEN sum_low_income_first_gen/denom_hs_admits ELSE percent_low_income_first_gen_fy20/100 END AS percent_low_income_first_gen_fy20,
        CASE WHEN Account = 'NATIONAL' THEN sum_active_hs/denom_annual_retention ELSE percent_active_FY20/100 END AS percent_annual_retention_fy20,
    FROM 
        (SELECT * EXCEPT (Account,sum_male,sum_low_income_first_gen,sum_active_hs,denom_hs_admits,denom_annual_retention,fiscal_year),
            AccountAbrev(Account)   AS Account, --transform Accounts to abbreviations to enable pivot 
            --percent_male_fy20/100 AS male_admits_outcome,
            CASE WHEN Account = 'National' THEN SUM(sum_male) OVER () ELSE sum_male END AS sum_male, --pull grand total, add value only to National
            CASE WHEN Account = 'National' THEN SUM(sum_low_income_first_gen) OVER () ELSE sum_low_income_first_gen END AS sum_low_income_first_gen, 
            CASE WHEN Account = 'National' THEN SUM(sum_active_hs)OVER () ELSE sum_active_hs END AS sum_active_hs,
            CASE WHEN Account = 'National' THEN SUM(denom_hs_admits)OVER () ELSE denom_hs_admits END AS denom_hs_admits,
            CASE WHEN Account = 'National' THEN SUM(denom_annual_retention)OVER () ELSE denom_annual_retention END AS denom_annual_retention,
            CASE WHEN fiscal_year IS NULL THEN 'FY20' ELSE fiscal_year END AS fiscal_year
        FROM recruit_and_retain_region)