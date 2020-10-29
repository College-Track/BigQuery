WITH contact_at AS (
  SELECT
    Contact_Id,
    Financial_Aid_Package__c,
    CASE
      WHEN Financial_Aid_Package__c IS NULL THEN NULL
      WHEN Financial_Aid_Package__c = "N/A" THEN NULL
      WHEN SPLIT(Financial_Aid_Package__c, "_") [OFFSET(1)] = "G" THEN 3
      WHEN SPLIT(Financial_Aid_Package__c, "_") [OFFSET(1)] = "Y" THEN 2
      WHEN SPLIT(Financial_Aid_Package__c, "_") [OFFSET(1)] = "R" THEN 1
      ELSE NULL
    END AS question_finance_Financial_Aid_Package_score,
    Filing_Status__c,
    CASE
      WHEN Filing_Status__c IS NULL THEN NULL
      WHEN Filing_Status__c = "N/A" THEN NULL
      WHEN SPLIT(Filing_Status__c, "_") [OFFSET(1)] = "G" THEN 3
      WHEN SPLIT(Filing_Status__c, "_") [OFFSET(1)] = "Y" THEN 2
      WHEN SPLIT(Filing_Status__c, "_") [OFFSET(1)] = "R" THEN 1
      ELSE NULL
    END AS question_finance_Filing_Status_score,
    Loans__c,
    CASE
      WHEN Loans__c IS NULL THEN NULL
      WHEN Loans__c = "N/A" THEN NULL
      WHEN SPLIT(Loans__c, "_") [OFFSET(1)] = "G" THEN 3
      WHEN SPLIT(Loans__c, "_") [OFFSET(1)] = "Y" THEN 2
      WHEN SPLIT(Loans__c, "_") [OFFSET(1)] = "R" THEN 1
      ELSE NULL
    END AS question_finance_Loans_score
  FROM
    `data-warehouse-289815.sfdc_templates.contact_at_template`
)
SELECT
  *
FROM
  contact_at
LIMIT
  10