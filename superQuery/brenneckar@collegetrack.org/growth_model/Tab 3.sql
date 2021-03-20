WITH gather_data AS (
  SELECT
    C.region_abrev,
    C.site_short,
    C.Contact_Id,
    C.hs_grad_year_c,
    A_T.GAS_Name
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` A_T ON A_T.AT_Id = C.contact_4_year_degree_earned_at_lookup_c
    WHERE C.college_track_status_c = '17A'
    AND A_T.GAS_Name NOT LIKE '%2020-21%' AND A_T.GAS_Name NOT LIKE '%2019-20%'
)

SELECT *
FROM gather_data