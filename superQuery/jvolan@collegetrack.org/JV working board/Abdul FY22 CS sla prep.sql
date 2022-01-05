SELECT
    student_c,
    id AS bb_app_id,
    total_service_earnings_c,
    total_ct_advised_earnings_c,
    (total_service_earnings_c + total_ct_advised_earnings_c) AS cs_1600_cap,

    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE scholarship_application_record_type_name = "Bank Book"