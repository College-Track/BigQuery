WITH gather_students AS 
(
    SELECT
    Contact_Id,
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

fy21_door AS  
(
    SELECT
    student_c AS d_contact_id,
    SUM(amount_awarded_c) AS fy21_DOOR_total,
 
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE scholarship_c = 'a3B46000000HWacEAG'
    AND academic_year_c = 'a1b46000000dRR8AAM'
    AND status_c = 'Won'
    GROUP BY student_c

),

get_efund AS
(
    SELECT
    st.student_c AS e_contact_id,
    st.academic_semester_c,
    amount_c,
    cat.academic_year_c

    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` cat ON st.academic_semester_c = cat.AT_Id
    WHERE scholarship_c = 'College Track Emergency Fund'
),

fy21_efund AS
(
    SELECT
    e_contact_id,
    SUM(amount_c) AS fy21_efund_total,

    FROM get_efund
    WHERE academic_year_c = 'a1b46000000dRR8AAM'
    GROUP BY e_contact_id
),

get_bb_at_ay AS
(
    SELECT
    st.student_c,
    st.academic_semester_c,
    st.amount_c,
    cat.academic_year_c
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` cat ON st.academic_semester_c = cat.AT_Id
    WHERE st.record_type_id = '01246000000ZNhtAAG'

),

bb_2021_ay21 AS
(
    SELECT
    student_c AS bb_contact_id,
    SUM(amount_c) AS fy21_bb_total,
    
    FROM get_bb_at_ay   
    WHERE academic_year_c = 'a1b46000000dRR8AAM'
    GROUP BY student_c
 ),
 
data_joined AS
(
    SELECT
    Contact_Id,
    full_name_c,
    site_short,
    high_school_graduating_class_c,
    College_Track_Status_Name,
    Current_school_name,
    Current_School_Type_c_degree,
    Current_Major_c,
    Current_Major_specific_c,
    current_second_major_c,
    Current_Minor_c,
    fy21_door.fy21_DOOR_total,
    fy21_efund.fy21_efund_total,
    bb_2021_ay21.fy21_bb_total,
    
    FROM gather_students
    LEFT JOIN fy21_door ON d_contact_id = Contact_Id
    LEFT JOIN fy21_efund ON e_contact_id = Contact_Id
    LEFT JOIN bb_2021_ay21 ON bb_contact_id = Contact_Id
)

    SELECT
    *
    FROM data_joined