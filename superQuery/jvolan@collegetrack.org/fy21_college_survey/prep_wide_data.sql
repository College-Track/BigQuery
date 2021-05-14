SELECT
    data_with_filters.*,
    CR.wellness_score_color	
    FROM data_with_filters
    LEFT JOIN `data-studio-260217.college_rubric.filtered_college_rubric`CR ON CR.Contact_Id = wide_contact_id