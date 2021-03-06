WITH gather_dream_schools AS (
  SELECT
    Contact_Id,
    site_c,
    full_name_c,
    A.Name AS school,
    A.SAT_c,
    A.GPA_Average_c,
    A.ACT_Composite_Average_c

  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
    LEFT JOIN `data-warehouse-289815.salesforce.college_aspiration_c` CA ON CA.student_c = Contact_Id 
    LEFT JOIN `data-warehouse-289815.salesforce.account` A ON A.Id = college_university_c
  WHERE
    college_track_status_c IN ('11A', '18a', '12A')
)
SELECT
  *
FROM
  gather_dream_schools
  WHERE school IS NOT NULL