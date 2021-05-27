
    SELECT
        CAT.student_c,
        site_short,
        MAX(
            CASE
                WHEN  grade_c != '8th Grade'
                    THEN 1
                ELSE 0
            END
        ) AS mse_reporting_group
    FROM
        `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
    WHERE 
    (
    (GAS_Name = 'Spring 2019-20 (Semester)'
    AND student_audit_status_c = 'Current CT HS Student') 
    AND
    (GAS_Name = 'Summer 2019-20 (Semester)'
    AND student_audit_status_c = 'Current CT HS Student'))
    GROUP BY
    site_short,
    CAT.student_c