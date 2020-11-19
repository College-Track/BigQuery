SELECT * EXCEPT(
_fivetran_synced,
admin_temp_1_c,
college_track_site_c,
college_track_status_c,
created_date, created_by_id, current_grade_c, high_school_class_c, last_modified_by_id, last_modified_date, last_referenced_date, last_viewed_date, system_modstamp  
)
FROM `data-warehouse-289815.salesforce.college_application_c`