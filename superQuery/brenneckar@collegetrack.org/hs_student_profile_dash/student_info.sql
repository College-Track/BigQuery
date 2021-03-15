SELECT
  Contact_Id,
  high_school_graduating_class_c,
  site_short,
  College_Track_Status_Name,
  email,
  phone,
  primary_contact_language_c
FROM
  `data-warehouse-289815.salesforce_clean.contact_template`
WHERE
  college_track_status_c IN ('18a', '11A', '12A', '13A')