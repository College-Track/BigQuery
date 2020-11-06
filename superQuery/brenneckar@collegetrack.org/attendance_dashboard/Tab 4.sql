WITH gather_attendance AS (
  SELECT
    Id,
    Workshop_Dosage_Type__c,
    SPLIT(RTRIM(Workshop_Dosage_Type__c, ";"), ';') AS dosage_combined,
    Attendance_Numerator__c,
    Attendance_Denominator__c,
    0 AS group_count
  FROM
    `data-warehouse-289815.salesforce_raw.Class_Attendance__c`
  WHERE
    Current_AT__c = TRUE

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
),
create_col_number AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY Id
      ORDER BY
        Id
    ) - 1 As group_count,
  from
    mod_dosage
)
SELECT
  MD.*,
  GA.Attendance_Numerator__c,
  GA.Attendance_Denominator__c,
  GA.Id AS ws_id
FROM
  create_col_number MD
  LEFT JOIN gather_attendance GA ON GA.Id = MD.Id
  AND MD.group_count = GA.group_count