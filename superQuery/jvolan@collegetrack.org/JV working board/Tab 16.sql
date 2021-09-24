with gather_ay_attednace_data AS
(
  SELECT
    cay.Contact_Id,
    AY_student_served,
    AY_Name,
    AY_fall_spring_attended_workshops,
    AY_fall_spring_enrolled_sessions,
    AY_fall_spring_attended_workshops/AY_fall_spring_enrolled_sessions AS ay_fall_spring_attendance_rate
    
    FROM `data-warehouse-289815.salesforce_clean.contact_ay_template` cay
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = cay.Contact_Id
    WHERE AY_Name IN ('AY 2018-19','AY 2019-20','AY 2020-21')
    AND AY_student_served = "High School"
    AND AY_fall_spring_enrolled_sessions > 0
)

    SELECT
    AY_Name,
    ROUND(AVG(ay_fall_spring_attendance_rate)*100,2)
    
    FROM gather_ay_attednace_data
    GROUP BY AY_Name