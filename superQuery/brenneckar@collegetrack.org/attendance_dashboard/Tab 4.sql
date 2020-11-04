WITH name_score AS (
  SELECT
    Id,
    SPLIT(Workshop_Dosage_Type__c, ';') AS nested_dosage
  FROM
    `data-warehouse-289815.salesforce_raw.Class_Attendance__c`)
  SELECT
    Id,dosage
  FROM
    name_score
    CROSS JOIN UNNEST(name_score.Dosage) AS dosage;
  LIMIT
    10