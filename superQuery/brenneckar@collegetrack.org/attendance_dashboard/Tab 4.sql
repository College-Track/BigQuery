WITH name_score AS (
  SELECT
    Id,
    SPLIT(Workshop_Dsoage_Type__c, ';') AS Dosage
  FROM
    `data-warehouse-289815.salesforce_raw.Class_Attendance__c`)
  SELECT
    *
  FROM
    name_score
    CROSS JOIN UNNEST(name_score.Dosage) AS score;
  LIMIT
    10