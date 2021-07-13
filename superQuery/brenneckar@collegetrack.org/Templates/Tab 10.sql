SELECT C.Contact_id,
      CAT.AT_Term_GPA AS most_recent_valid_term_gpa,
      CAT.AT_Cumulative_GPA AS most_recent_valid_cumulative_gpa

FROM `data-warehouse-289815.salesforce_clean.contact_template` C
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.Contact_Id = C.Contact_Id
WHERE CAT.current_valid_gpa_term = TRUE