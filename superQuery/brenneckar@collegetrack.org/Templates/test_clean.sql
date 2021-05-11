
CREATE OR REPLACE TABLE `data-warehouse-289815.salesforce_clean.test_clean` AS(



SELECT
  *
EXCEPT
  (
    _fivetran_synced,
    created_by_id,
    last_modified_by_id,
    last_modified_date,
    last_referenced_date,
    last_viewed_date,
    academic_year_c,
    admin_temp_1_c,
    -- contact_name_c,
    high_school_class_c,
    hs_grade_level_c,
    system_modstamp
  )
FROM
  `data-warehouse-289815.salesforce.test_c`
  WHERE is_deleted = false
)