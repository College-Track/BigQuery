SELECT *,
(us_citizen + english_primary_language + first_gen + househld_income_site) / 4 AS student_self_index
FROM `learning-agendas.index_project.site_z_scores`