SELECT
    site_short,
    SUM(total_bb_earnings_as_of_hs_grad_contact_c)
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE indicator_completed_ct_hs_program_c = 1
    AND site_short IN ('Boyle Heights','Watts')
    AND high_school_graduating_class_c = 2021
    GROUP BY site_short