SELECT
    sac.stc_course_name,
    COUNT(*)                                                          AS total_records,
    COUNT(sac.stc_verified_grade)                                     AS graded,
    COUNT(*) - COUNT(sac.stc_verified_grade)                          AS not_graded,
    ROUND(
        (COUNT(*) - COUNT(sac.stc_verified_grade))::numeric
        / COUNT(*) * 100, 1
    )                                                                 AS pct_not_graded
FROM student_acad_cred sac
INNER JOIN stc_statuses ss ON sac.student_acad_cred_id = ss.student_acad_cred_id
WHERE sac.stc_term = '2026SP'
    AND ss.stc_status NOT IN ('D', 'X')
GROUP BY sac.stc_course_name
HAVING COUNT(*) - COUNT(sac.stc_verified_grade) > 0
ORDER BY pct_not_graded DESC;
