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
    CROSS JOIN UNNEST(gather_attendance.dosage_combined) AS dosage_split
)

SELECT *,     ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Id) - 1 As C_NO,
from mod_dosage