 SELECT
    student_c,
    amount_c,
    transaction_status_c,
    earning_type_c,
    name,
    id AS bb_id,
    CAST(finance_reporting_date_c AS DATE) AS finance_reporting_date,
    CASE
      WHEN record_type_id = "01246000000ZNhsAAG"THEN "BB Disbursement"
      WHEN record_type_id = "01246000000ZNhtAAG"THEN "BB Earnings"
  END
    AS BB_Record_Type,
    CASE
      WHEN record_type_id = "01246000000ZNhsAAG"THEN amount_c
  END
    AS BB_Disbursement_Amount,
    CASE
      WHEN record_type_id = "01246000000ZNhtAAG"THEN amount_c
  END
    AS BB_Earnings_Amount,
    academic_year_c,
    FORMAT_DATE("%m", CURRENT_DATE()) AS report_month,
    CAST (CURRENT_DATE() AS DATE) AS report_date,
  FROM
    `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
  WHERE
    finance_reporting_date_c >= '2021-07-01'
    AND record_type_id = "01246000000ZNhsAAG"
    AND transaction_status_c = "Approved"
    OR record_type_id = "01246000000ZNhtAAG"
    AND finance_reporting_date_c >= '2021-07-01'