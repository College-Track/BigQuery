SELECT Contact_Id, most_recent_outreach_date, first_outreach_date, num_of_outreach_comms, avg_days_between_outreach, days_between_most_recent_outreach
FROM `data-studio-260217.cca_communication.filtered_cca_communication`
WHERE avg_days_between_outreach < 10