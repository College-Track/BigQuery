SELECT
    COUNT(AT_Id) AS at_count,
    COUNT(DISTINCT Contact_Id) AS ay_student_count,
    SUM(
        CASE
        WHEN type_of_degree_earned_c = "4-year" THEN 1
        ELSE 0
    END) AS degree_earned_count,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN `data-warehouse-289815.salesforce.account` ON id = school_c
    WHERE historically_black_college_univ_hbcu_c = TRUE
    AND student_audit_status_c IN ("Active: Post-Secondary","CT Alumni")
    GROUP BY historically_black_college_univ_hbcu_c
