    SELECT
    AT_Id,
    AT_Name,
    student_c,
    Contact_Id AS at_contact_id,
    site_short AS at_site,
    AT_Cumulative_GPA,

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE college_track_status_c = '15A'
    AND previous_as_c = TRUE