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
)

    select * from
(
select Contact_Id,AT_Term_GPA, row_number() over(partition by Contact_Id order by start_date_c) as rn
from gather_AT
)a where rn=1