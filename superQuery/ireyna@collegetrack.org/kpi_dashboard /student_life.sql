SELECT
        --student_c,
        site_short,
        /*SUM(
            CASE
            WHEN student_audit_status_c = 'Current CT HS Student' THEN 1
            ELSE 0
        END) AS current_at_count,*/
        Ethnic_background_c,
        Gender_c
    FROM
        `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
    --CT Status (AT) = Current CT HS Student during Spring 2019-20 AND Summer 2019-20
    GAS_Name IN ('Spring 2019-20 (Semester)', 'Summer 2019-20 (Semester)')
    AND grade_c != '8th Grade'
    GROUP BY
   -- student_c,
    site_short,
    Ethnic_background_c,
    Gender_c