/*
CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.audit_kpi_weird_targets`
OPTIONS
    (
    description= "This table pulls in targets that do not make sense for a numeric, percent or T/F target"
    )
AS 
*/


SELECT
    staff_list.first_name,
    staff_list.last_name,
    staff_list.team,
    staff_list.program_area,
    staff_list.site,
    staff_list.region
    
FROM `data-warehouse-289815.google_sheets.staff_list` AS staff_list
LEFT JOIN `data-warehouse-289815.google_sheets.individual_kpi_target` AS kpi_targets_submitted
    ON kpi_targets_submitted.enter_your_college_track_email_address = staff_list.email_address