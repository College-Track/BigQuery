    SELECT
    Contact_Id,
    AVG(AT_Term_GPA),
    AVG(AT_Cumulative_GPA),
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE site_short = "The Durant Center"
    AND College_Track_Status_Name = "Current CT HS Student"
    AND GAS_Name IN ("Fall 2020-21 (Semester)","Spring 2020-21 (Semester)")
    GROUP BY Contact_Id