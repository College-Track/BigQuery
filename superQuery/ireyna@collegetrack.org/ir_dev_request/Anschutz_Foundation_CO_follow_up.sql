SELECT
       COUNT(DISTINCT contact_id) AS student_total,
       site_short,
       
     --average GPA. Pulled from Spring 2020-21
       AVG(college_eligibility_gpa_11th_grade) AS avg_11th_cgpa,
    FROM
       `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE
        AY_2020_21_student_served_c = 'High School Student'
        AND region_short = 'Colorado'
    GROUP BY
      site_short