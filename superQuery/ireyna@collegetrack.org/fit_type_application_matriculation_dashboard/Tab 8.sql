SElect
    CASE WHEN fit_type_affiliation IS NULL THEN "did not enroll"
    ELSE fit_type_affiliation
    END AS fit_type_affiliation
 FROm `data-studio-260217.fit_type_pipeline.aggregate_data`