SELECT
        contact_id,
        site_short,
        Dream_Statement_filled_out_c,
        CASE
            WHEN high_school_graduating_class_c <> '2024' THEN 000
            WHEN (Dream_Statement_filled_out_c = True AND high_school_graduating_class_c = '2024') THEN 1
            ELSE 0
            END AS dream_declared
    FROM `data-warehouse-289815.salesforce_clean.contact_template` AS C
    WHERE college_track_status_c = '11A'