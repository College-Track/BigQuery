 # of active CO high school and college students for AY2021-22 broken out by Denver and Aurora site
         # of CO students at each partner high school broken out by Denver and Aurora site (see page 1 of attached March 2021 update)

# of Summer 2021 Corporate Residency Participants in CO

#Do we have enough data to update average GPA and GPA improvement data 
#GPA average
#Fall 2020-21 to Spring 2020-21 GPA improvement


--pull average cumulative GPA from Spring 2020-21
    SELECT
       COUNT(DISTINCT contact_id) AS student_total,
       site_short,
       
     --average GPA. Pulled from Spring 2020-21
       AVG(AT_Cumulative_GPA) AS avg_cgpa,
    FROM
       `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
       AY_Name = 'AY 2020-21'
       AND Term_c = 'Spring'
       AND AT_Record_Type_Name = 'High School Semester'
       AND AY_2020_21_student_served_c = 'High School Student'
       AND region_short = 'Colorado'
    GROUP BY
      site_short,
      at_grade_c,
      high_school_class_c
  ;
--pull term GPA from Fall 2020-21 to Spring 2020-21 to assess growth  
  WITH

term_gpa AS (
  
  SELECT 
    contact_id,
    site_short,
    CASE 
        WHEN term_c = 'Fall' THEN AT_Term_GPA
    END AS fall_term_gpa,
    CASE 
        WHEN term_c = 'Spring' THEN AT_Term_GPA
    END AS spring_term_gpa
        
    FROM
   `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
       AY_Name = 'AY 2020-21'
       AND Term_c <> 'Summer'
       AND AT_Record_Type_Name = 'High School Semester'
       AND AY_2020_21_student_served_c = 'High School Student'
       AND region_short = 'Colorado'
       
    GROUP BY
        site_short,
        AT_Term_GPA,
        term_c,
        contact_id
),

growth AS (
    SELECT
        contact_id,
        site_short,
        fall_term_gpa - spring_term_gpa AS gpa_term_growth
    FROM term_gpa
)

    SELECT 
        COUNT(DISTINCT contact_id),
        site_short,
        SUM(CASE 
            WHEN gpa_term_growth > 0.01 
            THEN 1
            ELSE 0
        END) gpa_term_growth
        
    FROM growth
    GROUP BY 
        --contact_id,
        site_short
        