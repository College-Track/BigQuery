WITH gather_AT AS
(
    SELECT
    Contact_Id,
    max(AT_Cumulative_GPA) AS AT_Cumulative_GPA,
    max(start_date_c) AS start_date_c
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE site_short = 'Ward 8'
    AND ay_2020_21_student_served_c = "High School Student"
    AND AT_Term_GPA IS NOT NULL
    GROUP BY Contact_Id
    ORDER BY start_date_c ASC
),

earliest_AT_term_gpa AS
(
    select * from
(
select
Contact_Id AS at_contact_id,
AT_Cumulative_GPA AS e_cgpa,
    row_number() over(partition by Contact_Id order by start_date_c) as rn
from gather_AT
)a where rn=1
)

    SELECT
    Contact_Id,
    high_school_graduating_class_c,
    site_short,
    College_Track_Status_Name,
    GAS_Name,
    earliest_AT_term_gpa.e_cgpa,
    CASE
        WHEN 
        (GAS_Name = 'Spring 2020-21 (Semester)'
        AND AT_Term_GPA IS NOT NULL) THEN (AT_Cumulative_GPA - earliest_AT_term_gpa.e_cgpa)
        ELSE 0
        END AS e_sp_gpa_growth,
    AT_Term_GPA,
    AT_Cumulative_GPA

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN earliest_AT_term_gpa ON at_contact_id = Contact_Id
    WHERE site_short = 'Ward 8'
    AND ay_2020_21_student_served_c = "High School Student"
    AND GAS_Name IN ('Fall 2020-21 (Semester)', 'Spring 2020-21 (Semester)')


/*
    SELECT
    Contact_Id,
    site_short,
    e_gpa,
    CASE
        WHEN GAS_Name = 'Fall 2020-21 (Semester)'
        AND AT_Cumulative_GPA >=3 THEN 1
        ELSE 0 
        END AS f_cgpa_3,
    CASE
        WHEN GAS_Name = 'Spring 2020-21 (Semester)'
        AND AT_Term_GPA IS NULL THEN 1
        ELSE 0
        END AS missing_spring_gpa,
    CASE
        WHEN GAS_Name = 'Spring 2020-21 (Semester)'
        AND AT_Term_GPA IS NOT NULL THEN 1
        ELSE 0
        END AS sp_t_gpa_growth_denom,
    CASE
        WHEN GAS_Name = 'Spring 2020-21 (Semester)'
        AND AT_Term_GPA IS NOT NULL
        AND e_sp_gpa_growth >0 THEN 1
        ELSE 0
        END AS sp_t_gpa_growth_num,
        
    FROM join_data
*/
    



