 WITH

fall_term_gpa AS (
  
  SELECT 
    contact_id,
    site_short,
    AT_Term_GPA AS fall_term_gpa
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
       AY_Name = 'AY 2020-21'
       AND Term_c = 'Fall'
       AND AT_Record_Type_Name = 'High School Semester'
       AND AY_2020_21_student_served_c = 'High School Student'
       AND region_short = 'Colorado'
       
    GROUP BY
        site_short,
        contact_id,
        AT_Term_GPA
),
spring_term_gpa AS (
    SELECT
    contact_id,
    site_short,
    AT_Term_GPA AS spring_term_gpa
        
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
       AY_Name = 'AY 2020-21'
       AND Term_c = 'Spring'
       AND AT_Record_Type_Name = 'High School Semester'
       AND AY_2020_21_student_served_c = 'High School Student'
       AND region_short = 'Colorado'
       
    GROUP BY
        site_short,
        AT_Term_GPA,
        contact_id
),

growth AS (
    SELECT
        fall.contact_id,
        fall.site_short,
        fall_term_gpa - spring_term_gpa AS gpa_term_growth
    FROM fall_term_gpa AS fall
    FULL OUTER JOIN spring_term_gpa AS spring
        ON fall.contact_id=spring.contact_id
)

    SELECT 
        COUNT(DISTINCT contact_id),
        site_short,
        SUM(CASE 
            WHEN gpa_term_growth > 0 
            THEN 1
            ELSE 0
        END) gpa_term_growth
        
    FROM growth
    GROUP BY 
        --contact_id,
        site_short