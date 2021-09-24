
  SELECT
    Contact_Id,
    AY_student_served,
    AY_Name,
    AY_fall_spring_attended_workshops,
    AY_fall_spring_enrolled_sessions,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_ay_template`
    WHERE AY_Name IN ('AY 2018-19','AY 2019-20','AY 2020-21')
    AND AY_fall_spring_enrolled_sessions > 0