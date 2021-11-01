/*SELECT
    COUNT(AT_Id) AS at_count,
    COUNT(DISTINCT Contact_Id) AS ay_student_count,
    COUNT(type_of_degree_earned_c) AS degree_earned_count,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN `data-warehouse-289815.salesforce.account` ON id = school_c
    WHERE historically_black_college_univ_hbcu_c = TRUE
    AND student_audit_status_c IN ("Active: Post-Secondary","CT Alumni")
    GROUP BY historically_black_college_univ_hbcu_c
*/

    SELECT 
    a.name,
    COUNT(Contact_Id) AS CT_alumni_count,

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    LEFT JOIN `data-warehouse-289815.salesforce.account`a ON a.name = college_4_year_degree_earned_c
    WHERE historically_black_college_univ_hbcu_c = TRUE
    AND College_Track_Status_Name = "CT Alumni"
    GROUP BY a.name
    ORDER BY CT_alumni_count DESC
