CREATE OR REPLACE TABLE `data-warehouse-289815.salesforce_clean.scholarship_application_clean` AS (
SELECT
  SA.*
EXCEPT(
    _fivetran_synced,
    last_modified_by_id,
    last_modified_date,
    last_referenced_date,
    last_viewed_date,
    years_since_hs_indicator_c,
    created_by_id,
    created_date
    
  ),
  RT.name AS scholarship_application_record_type_name
FROM
  `data-warehouse-289815.salesforce.scholarship_application_c` SA
  LEFT JOIN `data-warehouse-289815.salesforce.record_type` RT ON RT.Id = record_type_id
WHERE
  is_deleted = false
)