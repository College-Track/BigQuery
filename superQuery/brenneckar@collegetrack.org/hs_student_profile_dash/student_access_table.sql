SELECT
  Contact_Id,
  full_name_c,
  College_Track_Status_Name,
  high_school_graduating_class_c,
  site_short
FROM
  `data-warehouse-289815.salesforce_clean.contact_template`
WHERE
  college_track_status_c IN ('18a', '11A', '12A', '13A')
  AND years_since_hs_grad_c <= 0