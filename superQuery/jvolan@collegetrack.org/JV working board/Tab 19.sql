    SELECT
    Contact_Id,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AT_Grade_c = "Year 1"
    AND term_c = "Fall"
    AND site_short = "San Francisco"
    AND high_school_graduating_class_c = "2014"