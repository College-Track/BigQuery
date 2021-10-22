 # of active CO high school and college students for AY2021-22 broken out by Denver and Aurora site
         # of CO students at each partner high school broken out by Denver and Aurora site (see page 1 of attached March 2021 update)

# of Summer 2021 Corporate Residency Participants in CO

#Do we have enough data to update average GPA and GPA improvement data 
#GPA average
#Fall 2020-21 to Spring 2020-21 GPA improvement


--pull average cumulative GPA from Spring 2020-21
    SELECT
       --site_short,
       region_short,
       
     --average GPA. Pulled from Spring 2020-21
        AVG(AT_Cumulative_GPA) AS avg_cgpa,
        --SUM(CASE WHEN AT_Cumulative_GPA >= 3.25 THEN 1 ELSE 0 END) AS cumulative_gpa_3_25
        COUNT(DISTINCT contact_id) AS student_total,
    FROM
       `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
       AY_Name = 'AY 2020-21'
       AND Term_c = 'Spring'
       AND AT_Record_Type_Name = 'High School Semester'
       AND AY_2020_21_student_served_c = 'High School Student'
       AND region_short = 'Colorado'
    GROUP BY
      --site_short,
      region_short
  ;
--pull term GPA from Fall 2020-21 to Spring 2020-21 to assess growth  
  
  
  SELECT 
    full_name_c,
    contact_id,
    site_short,
    gpa_growth_prev_semester_c,
    CASE WHEN gpa_growth_prev_semester_c>0 THEN 1 ELSE 0 END AS gpa_growth_indicator,
    AT_Term_GPA
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
       AY_Name = 'AY 2020-21'
       AND Term_c = 'Spring'
       AND AT_Record_Type_Name = 'High School Semester'
       AND AY_2020_21_student_served_c = 'High School Student'
       AND region_short = 'Colorado'
       
    GROUP BY
        site_short,
        contact_id,
        AT_Term_GPA,
        full_name_c,
        gpa_growth_prev_semester_c,
        AT_Term_GPA
        ;
        
--pull 11th grade cga for class of 2022 and 2021 to compare
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
      site_short,
      high_school_graduating_class_c,
      region_short
     ;
--active HS students at partner high schools
    SELECT
        COUNT(DISTINCT contact_id) AS student_total,
        AT_School_Name,
        site_short
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
        region_short = 'Colorado'
        AND 
        AT_Record_Type_Name = 'High School Semester' AND
            (AT_School_Name LIKE '%Rangeview%' OR
            AT_School_Name  LIKE '%Gateway%' OR
            AT_School_Name  LIKE'%Kunsmiller%' OR
            AT_School_Name  LIKE '%Sheridan%' OR
            AT_School_Name  LIKE '%Abraham%' OR
            AT_School_Name  LIKE '%South%' OR
            AT_School_Name  LIKE '%John F. Kennedy%' OR
            AT_School_Name  LIKE '%Thomas Jefferson%')
        AND College_Track_Status_Name IN ('Current CT HS Student','Leave of Absence')
    GROUP BY
        site_short,
        AT_School_Name