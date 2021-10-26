  --historical count of terms, students & degrees earned from HBCUs--
 /*   
    SELECT
    AY_Name,
    site_short,
    COUNT(AT_Id) AS at_count,
    COUNT(DISTINCT Contact_Id) AS unique_student_count,
    COUNT(type_of_degree_earned_c) AS degree_earned_count,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN `data-warehouse-289815.salesforce.account` ON id = school_c
    WHERE historically_black_college_univ_hbcu_c = TRUE
    AND student_audit_status_c IN ("Active: Post-Secondary","CT Alumni")
    GROUP BY AY_Name, site_short
    */


WITH fy_door AS  
(
    SELECT
    student_c,
    SUM(amount_awarded_c) AS door_total,
    academic_year_c
 
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE scholarship_c = 'a3B46000000HWacEAG'
    AND status_c = 'Won'
    GROUP BY student_c, academic_year_c
),

fy_e_fund AS
(
    SELECT
    st.student_c,
    SUM(amount_c) AS e_fund_total,
    cat.academic_year_c

    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` cat ON st.academic_semester_c = cat.AT_Id
    WHERE scholarship_c = 'College Track Emergency Fund'
    GROUP BY st.student_c,cat.academic_year_c
),


gather_students AS 
( 
 SELECT
    Contact_Id,
    AY_Name,
    academic_year_c,
    site_short,
    school_c
   
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN `data-warehouse-289815.salesforce.account` ON id = school_c
    WHERE historically_black_college_univ_hbcu_c = TRUE
    AND student_audit_status_c IN ("Active: Post-Secondary","CT Alumni")
)
    SELECT
    Contact_Id,
    AY_Name,
    site_short,
    school_c,
    gs.academic_year_c,
    
    d.academic_year_c,
    d.door_total,
    ef.e_fund_total,
    
    
    FROM gather_students gs
    LEFT JOIN fy_door d ON d.student_c = Contact_Id AND d.academic_year_c = gs.academic_year_c
    LEFT JOIN fy_e_fund ef ON ef.student_c = Contact_Id AND ef.academic_year_c = gs.academic_year_c

    
    
/*
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
    SUM(amount_c) AS fy21_efund_total

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
    SUM(amount_c) AS fy21_bb_total
    
    FROM get_bb_at_ay   
    WHERE academic_year_c = 'a1b46000000dRR8AAM'
    GROUP BY student_c
 ),
 */
    


    