with gather_data AS (
  SELECT
    DISTINCT Contact_Id,
    full_name_c,
    ABS(
      DATE_DIFF(
        CURRENT_DATE(),
        first_outreach_date,
        DAY
      )
    ) AS days_between_first_last_outreach,
    most_recent_outreach_date,
    first_outreach_date,
    num_of_outreach_comms,
    avg_days_between_outreach
  FROM
    `data-studio-260217.cca_communication.filtered_cca_communication`
)
SELECT
  AVG(avg_days_between_outreach) AS avg_days_between_outreach,
  STDDEV(avg_days_between_outreach) AS std
  AVG(num_of_outreach_comms) AS num_of_outreach_comms,
  AVG(days_between_first_last_outreach) AS days_between_first_last_outreach,
  COUNT(Contact_Id) AS Contact_Id
FROM
  gather_data