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