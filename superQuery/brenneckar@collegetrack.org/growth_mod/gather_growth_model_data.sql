WITH gather_data AS (
  SELECT
    region_short,
    site_short,
    Contact_Id,
    AT_Id,
    student_audit_status_c,
    GAS_Name,
    AT_Record_Type_Name,
    grade_c,
    AY_Name
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    GAS_Name LIKE "%Spring%"
),
group_data AS (
  SELECT
    region_short,
    site_short,
    AY_Name,
    AT_Record_Type_Name,
    COUNT(Contact_Id)
  FROM
    gather_data
  GROUP BY
    region_short,
    site_short,
    AY_Name,
    AT_Record_Type_Name
)
SELECT
  *
FROM
  group_data