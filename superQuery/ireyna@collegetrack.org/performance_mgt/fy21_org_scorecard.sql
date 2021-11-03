SELECT 
        --* EXCEPT (site_short,Account),
        --mapRegion(Account)   AS Account  --Map Region based on Site + remap region abbreviations to region_short
        CASE WHEN Account = 'NATIONAL' THEN 'National' ELSE Account END AS Account

        FROM `org-scorecard-286421.aggregate_data.financial_sustainability_fy20`
        GROUP BY Account,__students,Capacity_Target,__Capacty,Fundraising_Target
