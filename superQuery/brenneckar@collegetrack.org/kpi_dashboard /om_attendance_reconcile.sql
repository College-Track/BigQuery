SELECT
  site_short,
  COUNT(distinct Class_Session_Id)
FROM
  `data-warehouse-289815.salesforce_clean.class_template` CT
  LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.AT_Id = CT.Academic_Semester_c
WHERE
  Outcome_c = 'Scheduled'
  AND (
    EXTRACT(
      MONTH
      FROM
        date_c
    ) < EXTRACT(
      MONTH
      FROM
        CURRENT_DATE()
    )
  )
  AND current_as_c = true
  AND is_deleted = false
GROUP BY site_short