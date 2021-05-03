SELECT SUM(accepted) as number_acceptances
FROM `data-studio-260217.college_applications.college_application_filtered_table`
where site_short = 'National'
#GROUP BY
#contact_id