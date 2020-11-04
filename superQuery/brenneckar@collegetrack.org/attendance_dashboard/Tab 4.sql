WITH name_score AS (
  SELECT
    Id,
    SPLIT(Workshop_Dosage_Type__c, ';') AS dosage_combined,
    Attendance_Numerator__c
  FROM
    `data-warehouse-289815.salesforce_raw.Class_Attendance__c`
     LIMIT
    10)
  SELECT
    Id, dosage_split,Attendance_Numerator__c
  FROM
    name_score
    CROSS JOIN UNNEST(name_score.dosage_combined) AS dosage_split