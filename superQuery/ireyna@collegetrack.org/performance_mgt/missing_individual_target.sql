SELECT 
    staff_list.first_name,
    staff_list.last_name,
    staff_list.full_name,
    great_select_your_name,
    staff_list.email_address,
    thanks_select_your_team_program_area,
    staff_list.team,
    staff_list.program_area,
    staff_list.site,
    staff_list.region
FROM  `data-warehouse-289815.google_sheets.staff_list` staff_list
LEFT JOIN  submitted_individual_kpis 
    ON program_area = thanks_select_your_team_program_area