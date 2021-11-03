
--site breakdown
    SELECT
        if_site_sort,
        site_short,
    --GPA data
        above_3_gpa AS students_above_3_gpa_numerator,
        above_325_gpa_seniors AS above_325_gpa_seniors_numerator,
        above_325_gpa_and_test_ready_seniors AS above_325_gpa_and_test_ready_seniors_numerator,
        high_school_student_count AS hs_students_denominator,
        non_opt_out_seniors AS senior_readiness_gpa_opt_ins_denominator,
        
    --matriculation data
        matriculation_numerator AS num_matriculation,
        matriculated_affordable AS num_matriculation_affordable,
        matriculated_best_good_situational AS num_matriculated_best_good_situational,
        college_first_enrolled_school_type_numerator AS matriculation_4yr,
        twelfth_grade_count AS senior_denominator,
        
    --persistence data
        indicator_persisted_into_2_nd_year_ct_numerator AS num_persistence,
        persistence_denominator,
    
    --on-track data
        on_track_numerator,
        on_track_denominator,
    
    --college students graduating with 1+ internship
        had_1_plus_internship_numerator,
        had_1_plus_internship_denominator,
        
    --6 year graduation rate
        grade_rate_6_years_current_class_numerator AS num_6_yr_grad_rate,
        grade_rate_6_years_current_class_denom,
    
    --alumni
        alumni_count,
        
    --MEMO data
        had_mse_numerator AS mse_numerator,
        had_mse_denominator AS mse_denominator,
        
        above_80_attendance_memo AS above_80_attendance_memo_orig,
        CASE WHEN above_80_attendance = 0 AND above_80_attendance_memo = 1
            THEN above_80_attendance_memo  ELSE above_80_attendance
            END AS attendance_numerator_memo,
        high_school_student_count

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`  