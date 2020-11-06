WITH gather_attendance AS (
  SELECT
    Id,
    Workshop_Dosage_Type__c,
    SPLIT(RTRIM(Workshop_Dosage_Type__c, ";"), ';') AS dosage_combined,
    Attendance_Numerator__c,
    Attendance_Denominator__c
  FROM
    `data-warehouse-289815.salesforce_raw.Class_Attendance__c`
  WHERE
    Current_AT__c = TRUE
  LIMIT
    1000
), mod_dosage AS (
  SELECT
    Id,
    Workshop_Dosage_Type__c,
    dosage_split,
    Attendance_Numerator__c AS mod_numerator,
    Attendance_Denominator__c AS mod_denominator
  FROM
    gather_attendance
    CROSS JOIN UNNEST(name_score.dosage_combined) AS dosage_split;
)
SELECT
  mod_dosage.Id,
  gather_attendance.Workshop_Dosage_Type__c,
  mod_dosage.dosage_split,
  mod_dosage.mod_numerator,
  mod_dosage_mod_denominator
FROM
  (
    SELECT
      DISTINCT id
    FROM
      gather_attendance
  ) AS all_names
  CROSS JOIN date_month
  LEFT JOIN mod_dosage ON all_names.id = mod_dosage.id
