 SELECT
        student_c,
        site_c,
        global_academic_year_c,
        program_participation_status_c,
        organization_c,
        role_c,
        hourly_pay_rate_c,
        record_type_id
        
    FROM `data-warehouse-289815.salesforce.career_readiness_c` 
    WHERE student_c IN ('0034600001TQqAsAAL',
                        '0034600001TQrd3AAD',
                        '0034600001TQpWBAA1',
                        '0034600001TQqwIAAT'
                        )