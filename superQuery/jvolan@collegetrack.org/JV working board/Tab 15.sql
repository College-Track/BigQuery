 WITH bb_balance AS (
  SELECT
    student_c,
    MAX(finance_bb_balance_total_c) AS Finance_BB_Balance,
  FROM
    `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
  WHERE
    record_type_id = "01246000000ZNi1AAG"
    AND finance_bb_balance_total_c > 0
  GROUP BY
    student_c ),

join_data AS   
(
  SELECT
    Contact_Id,
    Full_Name_c,
    site_abrev AS Site,
    current_cc_advisor_2_c AS Current_CCA,
    high_school_graduating_class_c AS HS_Class,
    College_Track_Status_Name AS CT_Status,
    bb_balance.Finance_BB_Balance,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  LEFT JOIN
    bb_balance
  ON
    bb_balance.student_c = Contact_Id
  WHERE
    College_Track_Status_c IN ('11A',
      '12A',
      '15A',
      '16A')
    AND bb_balance.Finance_BB_Balance IS NOT NULL
)

    SELECT
    *
    FROM join_data
    WHERE Contact_Id = "0031M0000334qQ7QAI"