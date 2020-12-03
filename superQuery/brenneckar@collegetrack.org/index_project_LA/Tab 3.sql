SELECT Contact_Id, AT_Id, AT_Grade_c, term_c, gpa_semester_cumulative_c,
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE college_track_status_c IN ('11A') AND gpa_semester_cumulative_c IS NOT NULL AND AT_Grade_c IN ('9th Grade','10th Grade') AND term_c != 'Summer'
ORDER BY Contact_Id, AT_Grade_c, term_c