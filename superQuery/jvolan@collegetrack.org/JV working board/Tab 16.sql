  SELECT
    cat.Contact_Id,
    SUM(attended_workshops_c) AS attended_workshops_c,
    SUM(enrolled_sessions_c) AS enrolled_sessions_c,
    SUM(attended_workshops_c)/SUM(enrolled_sessions_c) AS ay_attendance_rate
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` cat
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_ay_template` cay ON cay.Contact_Id = cat.Contact_Id
  WHERE
    cat.AY_Name = "AY 2020-21"
    AND term_c != 'Summer'
  GROUP BY
    Contact_Id