SELECT
       --site_short,
       region_short,
       high_school_graduating_class_c,
     --average GPA. Pulled from Spring 2020-21
       AVG(college_eligibility_gpa_11th_grade) AS avg_11th_cgpa,
       COUNT(DISTINCT contact_id) AS student_total
       
    FROM
       `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE
        AY_2020_21_student_served_c = 'High School Student'
        AND region_short = 'Colorado'
        AND high_school_graduating_class_c IN ('2021','2022')
    GROUP BY
     -- site_short,
      high_school_graduating_class_c,
      region_short