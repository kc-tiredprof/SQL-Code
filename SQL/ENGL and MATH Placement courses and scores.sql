SELECT
    M.Person_Id,
    M.Term,
    M.Subject,
    M.Course,
    CASE
        WHEN M.Course = 'ENGL-100'
        THEN 'Intro to College Composition'
        ELSE M.Title
    END AS Title,
    M.Grade ,
    M.Gender,
    M.RaceEthnicity,
    M.Age_As_Of_Course,
    (
        SELECT COALESCE(NC.STNC_SCORE, 0.0)
        FROM STUDENT_NON_COURSES NC
        WHERE NC.STNC_PERSON_ID = M.Person_Id
            AND NC.STNC_NON_COURSE = 'ALEKS.MTH'
            AND NC.STNC_START_DATE <= M.Start_Date
        ORDER BY NC.STUDENT_NON_COURSES_ADDDATE DESC
        LIMIT 1
    ) AS Aleks_Score,
    (
        SELECT COALESCE(NC.STNC_SCORE, 0.0)
        FROM STUDENT_NON_COURSES NC
        WHERE NC.STNC_PERSON_ID = M.Person_Id
            AND NC.STNC_NON_COURSE = 'ACT.MATH'
            AND NC.STNC_START_DATE <= M.Start_Date
        ORDER BY NC.STUDENT_NON_COURSES_ADDDATE DESC
        LIMIT 1
    ) AS Act_Math_Score,
    (
        SELECT COALESCE(NC.STNC_SCORE, 0.0)
        FROM STUDENT_NON_COURSES NC
        WHERE NC.STNC_PERSON_ID = M.Person_Id
            AND NC.STNC_NON_COURSE = 'ACT.ENG'
            AND NC.STNC_START_DATE <= M.Start_Date
        ORDER BY NC.STUDENT_NON_COURSES_ADDDATE DESC
        LIMIT 1
    ) AS Act_Engl_Score,
    (
        SELECT COALESCE(NC.STNC_SCORE, 0.0)
        FROM STUDENT_NON_COURSES NC
        WHERE NC.STNC_PERSON_ID = M.Person_Id
            AND NC.STNC_NON_COURSE = 'SAT.MATH'
            AND NC.STNC_START_DATE <= M.Start_Date
        ORDER BY NC.STUDENT_NON_COURSES_ADDDATE DESC
        LIMIT 1
    ) AS Sat_Math_Score,
    (
        SELECT COALESCE(NC.STNC_SCORE, 0.0)
        FROM STUDENT_NON_COURSES NC
        WHERE NC.STNC_PERSON_ID = M.Person_Id
            AND NC.STNC_NON_COURSE = 'SAT.ENGL'
            AND NC.STNC_START_DATE <= M.Start_Date
        ORDER BY NC.STUDENT_NON_COURSES_ADDDATE DESC
        LIMIT 1
    ) AS Sat_Engl_Score,
    (
        SELECT COALESCE(NC.STNC_SCORE, 0.0)
        FROM STUDENT_NON_COURSES NC
        WHERE NC.STNC_PERSON_ID = M.Person_Id
            AND NC.STNC_NON_COURSE = 'WBSTE.ENGL'
            AND NC.STNC_START_DATE <= M.Start_Date
        ORDER BY NC.STUDENT_NON_COURSES_ADDDATE DESC
        LIMIT 1
    ) AS Wbste_Engl_Score,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM STUDENT_NON_COURSES NC
            WHERE NC.STNC_PERSON_ID = M.Person_Id
                AND NC.STNC_NON_COURSE = 'MATH.GPA'
                AND NC.STNC_START_DATE <= M.Start_Date
        )
        THEN 'Y'
        ELSE 'N'
    END AS MATH_GPA,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM STUDENT_NON_COURSES NC
            WHERE NC.STNC_PERSON_ID = M.Person_Id
                AND NC.STNC_NON_COURSE = 'ENGL.GPA'
                AND NC.STNC_START_DATE <= M.Start_Date
        )
        THEN 'Y'
        ELSE 'N'
    END AS ENGL_GPA
FROM (
    SELECT
        STC.STC_PERSON_ID AS Person_Id,
        CASE P.GENDER
            WHEN 'F' THEN 'Female'
            WHEN 'M' THEN 'Male'
            ELSE 'Unreported'
        END AS Gender,
        CASE
            WHEN P1.PER_ETHNICS = 'HIS'
                OR R1.VAL_EXTERNAL_REPRESENTATION = 'Hispanic or Latino'
                OR R2.VAL_EXTERNAL_REPRESENTATION = 'Hispanic or Latino'
            THEN 'Hispanic/Latino'
            WHEN R2.VAL_EXTERNAL_REPRESENTATION IS NOT NULL
                AND R2.VAL_EXTERNAL_REPRESENTATION <> 'No Response'
            THEN 'Two or More Races'
            WHEN R1.VAL_EXTERNAL_REPRESENTATION = 'No Response'
                OR R1.VAL_EXTERNAL_REPRESENTATION IS NULL
            THEN 'Unreported'
            ELSE R1.VAL_EXTERNAL_REPRESENTATION
        END AS RaceEthnicity,
        FLOOR(EXTRACT(EPOCH FROM (T.TERM_START_DATE - P.BIRTH_DATE)) / 31556952) AS Age_As_Of_Course,
        STC.STC_TERM AS Term,
        T.TERM_START_DATE AS Term_Start_Date,
        T.TERM_END_DATE AS Term_End_Date,
        STC.STC_START_DATE AS Start_Date,
        STC.STC_SUBJECT AS Subject,
        REPLACE(STC.STC_COURSE_NAME, 'ENGL-100A', 'ENGL-100') AS Course,
        STC.STC_TITLE AS Title,
        COALESCE(CAST(G.GRD_GRADE AS VARCHAR(5)), 'Blank') AS Grade,
        ROW_NUMBER() OVER (PARTITION BY STC.STC_PERSON_ID, STC.STC_SUBJECT ORDER BY STC.STC_START_DATE) AS Subject_Order
    FROM
        PERSON P
        INNER JOIN STUDENT_ACAD_CRED STC ON P.ID = STC.STC_PERSON_ID
        INNER JOIN STC_STATUSES STAT ON STC.STUDENT_ACAD_CRED_ID = STAT.STUDENT_ACAD_CRED_ID
        INNER JOIN TERMS T ON STC.STC_TERM = T.TERMS_ID
        INNER JOIN STUDENT_COURSE_SEC SCS ON STC.STC_STUDENT_COURSE_SEC = SCS.STUDENT_COURSE_SEC_ID
        INNER JOIN COURSE_SECTIONS SEC ON SCS.SCS_COURSE_SECTION = SEC.COURSE_SECTIONS_ID
        LEFT JOIN GRADES G ON STC.STC_VERIFIED_GRADE = G.GRADES_ID
        LEFT JOIN PERSON_LS P1 ON P.ID = P1.ID AND P1.POS = 1
        LEFT JOIN PERSON_LS P2 ON P.ID = P2.ID AND P2.POS = 2
        LEFT JOIN VALS R1 ON P1.PER_RACES = R1.VAL_INTERNAL_CODE AND R1.VALCODE_ID = 'PERSON.RACES'
        LEFT JOIN VALS R2 ON P2.PER_RACES = R2.VAL_INTERNAL_CODE AND R2.VALCODE_ID = 'PERSON.RACES'
    WHERE
        STC.STC_SUBJECT IN ('ENGL', 'MATH')
        AND STC.STC_COURSE_NAME NOT IN ('MATH-030', 'MATH-034')
        AND (STAT.STC_STATUS IN ('A', 'N') OR G.GRD_GRADE = 'W')
        AND (SCS.SCS_PASS_AUDIT <> 'A' OR SCS.SCS_PASS_AUDIT IS NULL)
) M
WHERE
    M.Subject_Order = 1
   and m.term in ('2023FA', '2024SP', '2024SU', '2025SP', '2024FA')
    --AND M.Term_Start_Date >= CURRENT_DATE - INTERVAL '3 years'
    --AND M.Term_End_Date + INTERVAL '30 days' < CURRENT_DATE