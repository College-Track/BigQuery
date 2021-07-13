SELECT CAT.Contact_Id,
      C.most_recent_valid_term_gpa,
      C.most_recent_valid_cumulative_gpa

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON CAT.Contact_Id = C.Contact_Id