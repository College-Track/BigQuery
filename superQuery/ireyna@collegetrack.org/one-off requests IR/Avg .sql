WITH acceptance_by_student AS
(SELECT SUM(accepted) as number_acceptances, contact_id, site_short
FROM `data-studio-260217.college_applications.college_application_filtered_table`
-- site_short = 'Watts'
GROUP BY
contact_id,
site_short
)

SELECT number_acceptances
FROM acceptance_by_student
GROUP BY site_short,number_acceptances