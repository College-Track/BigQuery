WITH gather_AT AS
(
    SELECT
    Contact_Id,
    max(AT_Term_GPA) AS AT_Term_GPA,
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
AT_Term_GPA AS earliest_term_gpa,
    row_number() over(partition by Contact_Id order by start_date_c) as rn
from gather_AT
)a where rn=1
)

    SELECT
    Contact_Id,
    high_school_graduating_class_c,
    site_short,
    College_Track_Status_Name,
    earliest_AT_term_gpa.earliest_term_gpa
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN earliest_AT_term_gpa ON at_contact_id = Contact_Id
    WHERE site_short = 'Ward 8'
    AND ay_2020_21_student_served_c = "High School Student"