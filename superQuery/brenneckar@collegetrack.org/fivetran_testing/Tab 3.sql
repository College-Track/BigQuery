    SELECT
        contact_id,
        site_short,
        --% students completing the financial aid submission and verification processes
        --May need to confirm which college applications should be included (e.g. accepted and enrolled/deferred). Currently pulling any college app
        (
            SELECT
                student_c
            FROM
                `data-warehouse-289815.salesforce_clean.college_application_clean` AS subq1
            WHERE
                FA_Req_FAFSA_c = 'Submitted'
                AND (
                    verification_status_c IN ('Submitted', 'Not Applicable')
                )
                AND Contact_Id = student_c
            group by
                student_c
        ) AS gather_fafsa_verification,
        --% of acceptances to Affordable colleges. This will be done in 2 parts since this can live in 2 fields: Fit Type (Applied), Fit Type (Enrolled)
        --Pulling in students that were accepted to an affordable option. 
        --Accepted & Enrolled/Deferred Affordable options will also be pulled in, but in another query below since these will live in Fit Type (enrolled) field
        (
            SELECT
                student_c
            FROM
                `data-warehouse-289815.salesforce_clean.college_application_clean` AS subq1
            WHERE
                (
                    admission_status_c = "Accepted"
                    AND College_Fit_Type_Applied_c IN ("Best Fit", "Good Fit", "Local Affordable")
                )
                AND Contact_Id = student_c
            group by
                student_c
        ) AS applied_accepted_affordable,
        --% of acceptances to Affordable colleges; % hs seniors who matriculate to affordable college
        --Pulling in from Fit Type (enrolled)
        --Will also be used to project matriculation to affordable colleges
        (
            SELECT
                student_c
            FROM
                `data-warehouse-289815.salesforce_clean.college_application_clean` AS subq2
            WHERE
                admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")
                AND fit_type_enrolled_c IN (
                    "Best Fit",
                    "Good Fit",
                    "Local Affordable",
                    "Situational"
                )
                AND Contact_Id = student_c
            group by
                student_c
        ) AS accepted_enrolled_affordable,
        --% accepted to Best Fit, Good Fit
        --Same logic as the 2 queries above, except only looking at Good Fit and Best Fit in Fit Type (Applied)     
        (
            SELECT
                student_c
            FROM
                `data-warehouse-289815.salesforce_clean.college_application_clean` AS subq4
            WHERE
                admission_status_c = "Accepted"
                AND College_Fit_Type_Applied_c IN ("Best Fit", "Good Fit", "Situational")
                AND Contact_Id = student_c
            group by
                student_c
        ) AS applied_accepted_best_good_situational,
        --% accepted to Best Fit, Good Fit; % hs seniors who matriculate to Good/Best/Situational
        --Same logic as the 2 queries above, except only looking at Good Fit and Best Fit in Fit Type (Enrolled) 
        -- Will also be used to project matriculation
        (
            SELECT
                student_c
            FROM
                `data-warehouse-289815.salesforce_clean.college_application_clean` AS subq5
            WHERE
                admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")
                AND fit_type_enrolled_c IN ("Best Fit", "Good Fit", "Situational")
                AND Contact_Id = student_c
            group by
                student_c
        ) AS accepted_enrolled_best_good_situational,
        --% applying to Best Fit and Good Fit colleges
        (
            SELECT
                student_c
            FROM
                `data-warehouse-289815.salesforce_clean.college_application_clean` AS subq3
            WHERE
                College_Fit_Type_Applied_c IN ("Best Fit", "Good Fit")
                AND Contact_Id = student_c
            group by
                student_c
        ) AS applied_best_good_situational,
    FROM
        `data-warehouse-289815.salesforce_clean.contact_template`
 
    WHERE
        college_track_status_c = '11A'
        AND grade_c = '12th Grade'