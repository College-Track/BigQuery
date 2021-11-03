
--site breakdown
    SELECT
        final_eoy.if_site_sort,
        final_eoy.site_short,
    --GPA data
        updated_gpa_hs.above_3_gpa AS students_above_3_gpa_numerator,
        updated_gpa_hs.above_325_gpa_seniors AS above_325_gpa_seniors_numerator,
        updated_gpa_hs.above_325_gpa_and_test_ready_seniors AS above_325_gpa_and_test_ready_seniors_numerator,
        updated_gpa_hs.high_school_student_count AS hs_students_denominator,
        updated_gpa_hs.non_opt_out_seniors AS senior_readiness_gpa_opt_ins_denominator,
        
    --matriculation data
        final_eoy.matriculation_numerator AS num_matriculation,
        final_eoy.matriculated_affordable AS num_matriculation_affordable,
        final_eoy.matriculated_best_good_situational AS num_matriculated_best_good_situational,
        final_eoy.college_first_enrolled_school_type_numerator AS matriculation_4yr,
        final_eoy.twelfth_grade_count AS senior_denominator,
        
    --persistence data
        final_eoy.indicator_persisted_into_2_nd_year_ct_numerator AS num_persistence,
        final_eoy.persistence_denominator,
    
    --on-track data
        final_eoy.on_track_numerator,
        final_eoy.on_track_denominator,
    
    --college students graduating with 1+ internship
        final_eoy.had_1_plus_internship_numerator,
        final_eoy.had_1_plus_internship_denominator,
        
    --6 year graduation rate
        final_eoy.grade_rate_6_years_current_class_numerator AS num_6_yr_grad_rate,
        final_eoy.grade_rate_6_years_current_class_denom,
    
    --alumni
        final_eoy.alumni_count,
        
    --MEMO data
        final_eoy.had_mse_numerator AS mse_numerator,
        final_eoy.had_mse_denominator AS mse_denominator,
        
        final_eoy.above_80_attendance_memo AS above_80_attendance_memo_orig,
        CASE WHEN final_eoy.above_80_attendance = 0 AND final_eoy.above_80_attendance_memo = 1
            THEN final_eoy.above_80_attendance_memo  ELSE final_eoy.above_80_attendance
            END AS attendance_numerator_memo,
        final_eoy.high_school_student_count

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`  AS final_eoy
    LEFT JOIN `data-studio-260217.performance_mgt.fy21_eoy_hs_metrics` AS updated_gpa_hs ON final_eoy.site_short=updated_gpa_hs.site_short
    ;
--region breakdown
SELECT
        region_short,
        
        SUM(matriculation_numerator) AS num_matriculation,
        SUM(matriculated_affordable) AS num_matriculation_affordable,
        SUM(matriculated_best_good_situational) AS num_matriculated_best_good_situational,
        SUM(college_first_enrolled_school_type_numerator) AS matriculation_4yr,
        SUM(twelfth_grade_count) AS senior_denominator,
    
    --3.0 & 3.25 GPA data
        SUM(above_3_gpa)AS students_above_3_gpa_numerator,
        SUM(above_325_gpa_seniors) AS above_325_gpa_seniors_numerator,
        SUM(above_325_gpa_and_test_ready_seniors) AS above_325_gpa_and_test_ready_seniors_numerator,
        SUM(high_school_student_count) AS hs_students_denominator,
        SUM(non_opt_out_seniors) AS senior_readiness_gpa_opt_ins_denominator,
        
    --persistence data
        SUM(indicator_persisted_into_2_nd_year_ct_numerator) AS num_persistence,
        SUM(persistence_denominator) AS persistence_denominator,
    
    --on-track data
        SUM(on_track_numerator) AS on_track_numerator,
        SUM(on_track_denominator) AS on_track_denominator,
    
    --college students graduating with 1+ internship
        SUM(had_1_plus_internship_numerator) AS had_1_plus_internship_numerator,
        SUM(had_1_plus_internship_denominator) AS had_1_plus_internship_denominator,
        
    --6 year graduation rate
        SUM(grade_rate_6_years_current_class_numerator) AS num_6_yr_grad_rate,
        SUM(grade_rate_6_years_current_class_denom) AS grade_rate_6_years_current_class_denom,
    
    --alumni
        SUM(alumni_count) AS alumni_count,
    
    --MEMO data
        SUM(had_mse_numerator) AS mse_numerator,
        SUM(had_mse_denominator) AS mse_denominator,
        
        SUM(above_80_attendance_memo) AS above_80_attendance_memo_orig,
        
        SUM(CASE WHEN above_80_attendance = 0 AND above_80_attendance_memo = 1
            THEN above_80_attendance_memo  ELSE above_80_attendance
            END) AS attendance_numerator_memo,
        SUM(high_school_student_count) AS high_school_student_count,

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`
    GROUP BY
        region_short
