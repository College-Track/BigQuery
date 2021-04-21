SELECT my_site_is_run_effectively_examples_i_know_how_to_find_zoom_links_i_receive_site, count(*)
FROM `data-studio-260217.surveys.fy21_hs_survey` S
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CT ON CT.Contact_Id = S.contact_id
GROUP BY my_site_is_run_effectively_examples_i_know_how_to_find_zoom_links_i_receive_site