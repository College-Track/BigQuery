WITH gather_students AS 
(
    SELECT
    Contact_Id,
    x_18_digit_id_c,
    full_name_c,
    site_short,
    high_school_graduating_class_c,
    College_Track_Status_Name,
    Current_school_name,
    Current_School_Type_c_degree,
    Current_Major_c,
    Current_Major_specific_c,
    current_second_major_c,
    Current_Minor_c
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c = '15A'
    
    AND 
    (Current_Major_c = 'Arts: Design, Performing, or Visual'
     
    OR
    ((Current_school_name Like '%Art%'
    OR Current_school_name LIKE '%Film%'
    OR Current_school_name LIKE '%Photography%'
    OR Current_school_name LIKE '%Fashion%'
    OR Current_school_name LIKE '%Design%'
    OR Current_school_name LIKE '%Music%')
    AND
    (Current_school_name NOT LIKE '%Swarthmore College%'
    OR Current_school_name NOT LIKE '%Dartmouth College%'
    OR Current_school_name NOT LIKE '%Hobart William Smith Colleges%'))
  
    
    OR 
    (Current_Minor_c Like '%Art%'
    OR Current_Minor_c LIKE '%Film%'
    OR Current_Minor_c LIKE '%Photography%'
    OR Current_Minor_c LIKE '%Fashion%'
    OR Current_Minor_c LIKE '%Design%'
    OR Current_Minor_c LIKE '%Music%')
    )
    
),

door_e_fund AS  
(
    SELECT
    student_18_digit_contact_id_c AS s_contact_id,
    scholarship_c,
    SUM(amount_c) AS total_amount,
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE scholarship_c IN ('DOOR','College Track Emergency Fund')
    AND academic_year_c = 'AY 2020-21'
    GROUP BY student_18_digit_contact_id_c, scholarship_c

),

bb_2021_ay21 AS
(
    SELECT
    student_18_digit_contact_id_c AS bb_contact_id,
    SUM(amount_c) AS fy21_bb_total,
    
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE academic_year_c = 'AY 2020-21'
    AND record_type_id = '01246000000ZNhtAAG'
    GROUP BY student_18_digit_contact_id_c
 ),
 
data_joined AS
(
    SELECT
    *,
    door_e_fund.scholarship_c,
    door_e_fund.total_amount,
    bb_2021_ay21.fy21_bb_total,
    
    FROM gather_students
    LEFT JOIN door_e_fund ON s_contact_id = x_18_digit_id_c
    LEFT JOIN bb_2021_ay21 ON bb_contact_id = x_18_digit_id_c
)

    SELECT
    *
    FROM data_joined