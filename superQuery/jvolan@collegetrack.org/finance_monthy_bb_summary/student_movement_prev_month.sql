WITH ct_site 
AS( 
    SELECT contact_id, 
    name AS student, 
    HIGH_SCHOOL_GRADUATING_CLASS_c AS hs_class, 
    site_short, region_short, college_track_status_name, 
    
    FROM data-warehouse-289815.salesforce_clean.contact_template
    ), 
    
/*status_history 
AS( 
    SELECT 
    contact_c,
    name AS movement_type,
    Academic_Semester_c,
    academic_year_lu_c,
    Start_Date_c,
    Days_at_this_Stage_c,
    extract(Month FROM Start_Date_c) AS month,
    extract(Month FROM CURRENT_DATE()) AS current_month,
    extract(month from date_sub(current_date,interval 1 Month)) AS prev_month, 

    FROM data-warehouse-289815.salesforce.contact_pipeline_history_c 
    WHERE name in ('Went on Leave of Absence','Became Inactive Post-Secondary','Dismissed/Left CT HS Program','Became CT Alumni')
),

*/

status_history_prev_month_only AS
(
    SELECT
    *
    
    FROM data-warehouse-289815.salesforce.contact_pipeline_history_c 
    WHERE     
    extract(month from date_sub(current_date,interval 1 Month)) = extract(Month FROM Start_Date_c)
)   
    SELECT 
    status_history_prev_month_only.*, 
    ct_site.student, 
    ct_site.site_short, 
    ct_site.region_short, 
    ct_site.hs_class, 
    ct_site.college_track_status_name, 
    
    FROM status_history_prev_month_only LEFT JOIN ct_site ON ct_site.contact_id = contact_c WHERE ct_site.site_short NOT IN ('Arlen')