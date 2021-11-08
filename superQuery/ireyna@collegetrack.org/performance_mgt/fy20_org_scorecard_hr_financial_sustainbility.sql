SELECT 
        * --EXCEPT (Account,string_field_5),
       -- mapRegion(Account)  AS Region --mapping site names and region abbreviations to region_short
        FROM`org-scorecard-286421.aggregate_data.HR_outcomes_identity`
        WHERE Account IS NOT NULL