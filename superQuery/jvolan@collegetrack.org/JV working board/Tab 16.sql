SELECT
x_18_digit_id_c,
full_name_c,
site,
College_Track_Status_Name,
total_bank_book_balance_contact_c

FROM `data-warehouse-289815.salesforce_clean.contact_template`
WHERE college_track_status_c IN ('11A','12A','15A')
OR (college_track_status_c = '16A'
AND total_bank_book_balance_contact_c >0)