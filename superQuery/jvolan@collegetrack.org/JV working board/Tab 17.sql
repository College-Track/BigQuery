
  SELECT
    cat.Contact_Id,
    cat.ay_2020_21_student_served_c,
    MAX(AT_Cumulative_GPA)
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` cat
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_ay_template` cay ON cay.Contact_Id = cat.Contact_Id
  WHERE
    cat.AY_Name = "AY 2020-21"
    AND term_c = 'Spring'
    AND ay_2020_21_student_served_c = "High School Student"
    AND site_short IN ("East Palo Alto", "Oakland", "San Francisco")
    AND AT_Cumulative_GPA IS NULL
    GROUP BY Contact_Id, ay_2020_21_student_served_c