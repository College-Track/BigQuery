with gather_ay_gpa_data AS
(
  SELECT
    cay.Contact_Id,
    AY_student_served,
    AY_Name,
    AY_Cumulative_GPA,
    CASE
        WHEN AY_Cumulative_GPA >= 3 THEN 1
        ELSE 0
    END AS ay_cgpa_3,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_ay_template` cay
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = cay.Contact_Id
    WHERE AY_Name IN ('AY 2018-19','AY 2019-20','AY 2020-21')
    AND AY_student_served = "High School"
    AND site_short IN  ("East Palo Alto", "Oakland", "San Francisco")
    AND 
    (AY_Name = "AY 2020-21"
    AND AY_Cumulative_GPA IS NOT NULL)
)

    SELECT
    AY_Name,
    SUM(ay_cgpa_3) AS ay_cgpa_3_num,
    COUNT(ay_cgpa_3) AS ay_cgpa_3_denom,
    Round(SUM(ay_cgpa_3) / COUNT(ay_cgpa_3),2) AS ay_cgpa_3_denom,
    
    FROM gather_ay_gpa_data
    GROUP BY AY_Name

    