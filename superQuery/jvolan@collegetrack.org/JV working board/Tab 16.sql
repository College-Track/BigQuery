  SELECT
    cat.Contact_Id,
    SUM(attended_workshops_c) AS attended_workshops_c,
    SUM(enrolled_sessions_c) AS enrolled_sessions_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` cat
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_ay_template` cay ON cay.Contact_Id = cat.Contact_Id
  WHERE
    cat.AY_Name = "AY 2020-21"
    AND term_c != 'Summer'
    AND ay_2020_21_student_served_c = 'TRUE'
    GROUP BY Contact_Id