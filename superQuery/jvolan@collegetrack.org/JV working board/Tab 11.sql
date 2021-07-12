    SELECT
    count(Contact_Id) AS at_count,
    AT_id,
    Max(AT_Cumulative_GPA),

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE college_track_status_c = '15A'
    AND previous_as_c = TRUE
    GROUP BY AT_Id
    LIMIT 1