 SELECT
       COUNT(DISTINCT contact_id) AS student_total,
       site_short,
       
     --average GPA. Pulled from Spring 2020-21
       AVG(AT_Cumulative_GPA) AS avg_cgpa,
       SUM(CASE WHEN AT_Cumulative_GPA >= 3.25 THEN 1 ELSE 0 END) AS cumulative_gpa_3_25
    FROM
       `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
       AY_Name = 'AY 2020-21'
       AND Term_c = 'Spring'
       AND AT_Record_Type_Name = 'High School Semester'
       AND AY_2020_21_student_served_c = 'High School Student'
       AND region_short = 'Colorado'
       AND ay_2020_21_student_served_c ='High School Student'
    GROUP BY
      site_short