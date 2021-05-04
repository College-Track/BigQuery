SELECT
    AT_Id,
    Contact_Id AS at_contact_id,
    site_short AS at_site,
    CASE    
        WHEN filing_status_c = "Filed for next year's financial aid" THEN 1
        ELSE 0
    END AS indicator_fafsa_complete,
    CASE
        WHEN 
        loans_c IN ("Not using private loans, PLUS loans, or consumer debt to finance education", "Using private and/or PLUS loans but on track to owe less than $30k at graduation") THEN 1
        ELSE 0
    END AS indicator_loans_less_30k_loans
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = true
    AND college_track_status_c = '15A'