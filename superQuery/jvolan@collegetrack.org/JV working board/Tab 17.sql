
  SELECT
    Contact_Id,
    ay_2020_21_student_served_c,
    high_school_graduating_class_c,
    site_short,
    AT_Name,
    CASE
        WHEN AT_Cumulative_GPA >= 3 THEN 1
        ELSE 0
    END AS sp_20_21_cgpa_3
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    
  
    WHERE GAS_Name = "Spring 2020-21 (Semester)"
    AND ay_2020_21_student_served_c = "High School Student"
    AND site_short IN ("East Palo Alto", "Oakland", "San Francisco")
    AND high_school_graduating_class_c = '2021'
 

    