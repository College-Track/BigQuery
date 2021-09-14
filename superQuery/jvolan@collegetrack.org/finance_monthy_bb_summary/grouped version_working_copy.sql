
WITH bb_balance AS
(
    SELECT
    student_c,
    max(finance_bb_balance_total_c) as Finance_BB_Balance
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE record_type_id = "01246000000ZNi1AAG"
    AND finance_bb_balance_total_c > 0
    GROUP BY student_c
 ),


student_list_bb_balance AS
(
 SELECT
    -- Select fields from templates
    Contact_Id,
    Full_Name_c,
    site_abrev,
    current_cc_advisor_2_c,
    high_school_graduating_class_c,
    bb_balance.Finance_BB_Balance,
    
    FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
    LEFT JOIN bb_balance ON bb_balance.student_c = Contact_Id
    WHERE College_Track_Status_c IN ('11A', '12A','15A', '16A') 
),

bb_d_fy AS
(
SELECT
    student_c,
    SUM (amount_c) as bb_disbursement_total,
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE
    record_type_id = "01246000000ZNhsAAG"
    AND finance_reporting_date_c >= '2021-07-01'
    AND transaction_status_c = "Approved"
    GROUP BY student_c
    
),

--bb earnings fy to date  
bb_e_fy AS
(
    SELECT
    student_c,
    SUM (amount_c) as bb_earnings_total,
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE
    record_type_id = "01246000000ZNhtAAG"
    AND created_date >= '2021-07-01'
    AND amount_c > 0
    GROUP BY student_c
),

clean_student_bb_summary AS
(
SELECT
student_list_bb_balance.*,
bb_d_fy.bb_disbursement_total,
bb_e_fy.bb_earnings_total,

FROM student_list_bb_balance
LEFT JOIN bb_d_fy ON bb_d_fy.student_c = student_list_bb_balance.Contact_Id
LEFT JOIN bb_e_fy ON bb_e_fy.student_c = student_list_bb_balance.Contact_Id
)

SELECT
*,
FORMAT_DATE("%m", CURRENT_DATE()) AS report_month,
FORMAT_DATE("%x", CURRENT_DATE()) AS report_date,
FROM
clean_student_bb_summary
WHERE Finance_BB_Balance >0

-- maybe add a column here that stamps the month & one that does today's date month. that way each table/scheduled query would have a month and date connected to it. DONE
-- could then be used in data studio as filter
-- other option, is to actuall use this query just to get all the raw data together, then in data studio I can create the aggregate fields for a summary table? then also have.
    -- the other raw bb disburse & earnings