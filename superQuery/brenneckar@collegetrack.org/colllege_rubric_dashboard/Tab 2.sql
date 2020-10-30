WITH contact_at AS (
  SELECT
    Contact_Id,
    Financial_Aid_Package__c,
    `data-studio-260217.college_rubric.format_question_as_num`(Financial_Aid_Package__c) as TEST,
    CASE
      WHEN Financial_Aid_Package__c IS NULL THEN NULL
      WHEN Financial_Aid_Package__c = "N/A" THEN NULL
      WHEN SPLIT(Financial_Aid_Package__c, "_") [OFFSET(1)] = "G" THEN 3
      WHEN SPLIT(Financial_Aid_Package__c, "_") [OFFSET(1)] = "Y" THEN 2
      WHEN SPLIT(Financial_Aid_Package__c, "_") [OFFSET(1)] = "R" THEN 1
      ELSE NULL
    END AS question_finance_Financial_Aid_Package_score,
    -- CASE
    --   WHEN Filing_Status__c IS NULL THEN NULL
    --   WHEN Filing_Status__c = "N/A" THEN NULL
    --   WHEN SPLIT(Filing_Status__c, "_") [OFFSET(1)] = "G" THEN 3
    --   WHEN SPLIT(Filing_Status__c, "_") [OFFSET(1)] = "Y" THEN 2
    --   WHEN SPLIT(Filing_Status__c, "_") [OFFSET(1)] = "R" THEN 1
    --   ELSE NULL
    -- END AS question_finance_Filing_Status_score,
    -- CASE
    --   WHEN Loans__c IS NULL THEN NULL
    --   WHEN Loans__c = "N/A" THEN NULL
    --   WHEN SPLIT(Loans__c, "_") [OFFSET(1)] = "G" THEN 3
    --   WHEN SPLIT(Loans__c, "_") [OFFSET(1)] = "Y" THEN 2
    --   WHEN SPLIT(Loans__c, "_") [OFFSET(1)] = "R" THEN 1
    --   ELSE NULL
    -- END AS question_finance_Loans_score,
  FROM
    `data-warehouse-289815.sfdc_templates.contact_at_template`
  WHERE
    AT_Record_Type_Name = "College/University Semester"
    AND Current_CT_Status__c = "Active: Post-Secondary"
)
SELECT
  *,
--   case
--     when question_finance_Loans_score IS NOT NULL then 1
--     else 0
--   end + case
--     when question_finance_Filing_Status_score IS NOT NULL then 1
--     else 0
--   end + case
--     when question_finance_Financial_Aid_Package_score IS NOT NULL then 1
--     else 0
--   end AS total
FROM
  contact_at
LIMIT
  5