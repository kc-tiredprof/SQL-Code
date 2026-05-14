WITH DedupedCourses AS (
    SELECT DISTINCT
        stc_person_id,
        stc_course_name
    FROM STUDENT_ACAD_CRED SAC 
    INNER JOIN STC_STATUSES SS 
        ON SAC.STUDENT_ACAD_CRED_ID = SS.STUDENT_ACAD_CRED_ID 
        AND POS = 1
    WHERE stc_person_id IN (
'0066915'
        
    )
    AND stc_course_name NOT LIKE 'CKICK%' and stc_course_name not like 'MENU%' and STC_COURSE_NAME not like 'XRDG%'
    and STC_COURSE_NAME not like 'XXH%' and STC_COURSE_NAME not like 'XW%' and STC_COURSE_NAME not like 'XM%'
),

NumberedCourses AS (
    SELECT
        stc_person_id,
        stc_course_name,
        ROW_NUMBER() OVER (
            PARTITION BY stc_person_id 
            ORDER BY stc_course_name
        ) AS rn
    FROM DedupedCourses
)

SELECT
    stc_person_id,
    MAX(CASE WHEN rn = 1 THEN stc_course_name END) AS Course1,
    MAX(CASE WHEN rn = 2 THEN stc_course_name END) AS Course2,
    MAX(CASE WHEN rn = 3 THEN stc_course_name END) AS Course3,
    MAX(CASE WHEN rn = 4 THEN stc_course_name END) AS Course4,
    MAX(CASE WHEN rn = 5 THEN stc_course_name END) AS Course5,
    MAX(CASE WHEN rn = 6 THEN stc_course_name END) AS Course6,
    MAX(CASE WHEN rn = 7 THEN stc_course_name END) AS Course7,
    MAX(CASE WHEN rn = 8 THEN stc_course_name END) AS Course8,
    MAX(CASE WHEN rn = 9 THEN stc_course_name END) AS Course9,
    MAX(CASE WHEN rn = 10 THEN stc_course_name END) AS Course10,
    MAX(CASE WHEN rn = 11 THEN stc_course_name END) AS Course11,
    MAX(CASE WHEN rn = 12 THEN stc_course_name END) AS Course12, 
    MAX(CASE WHEN rn = 13 THEN stc_course_name END) AS Course13,
    MAX(CASE WHEN rn = 14 THEN stc_course_name END) AS Course14, 
    MAX(CASE WHEN rn = 15 THEN stc_course_name END) AS Course15, 
    MAX(CASE WHEN rn = 16 THEN stc_course_name END) AS Course16,
    MAX(CASE WHEN rn = 17 THEN stc_course_name END) AS Course17, 
    MAX(CASE WHEN rn = 18 THEN stc_course_name END) AS Course18, 
    MAX(CASE WHEN rn = 19 THEN stc_course_name END) AS Course19,
    MAX(CASE WHEN rn = 20 THEN stc_course_name END) AS Cours20,
    MAX(CASE WHEN rn = 21 THEN stc_course_name END) AS Cours21, 
    MAX(CASE WHEN rn = 22 THEN stc_course_name END) AS Cours22, 
    MAX(CASE WHEN rn = 23 THEN stc_course_name END) AS Cours23,
    MAX(CASE WHEN rn = 24 THEN stc_course_name END) AS Cours24, 
    MAX(CASE WHEN rn = 25 THEN stc_course_name END) AS Cours25,
    MAX(CASE WHEN rn = 26 THEN stc_course_name END) AS Cours26, 
    MAX(CASE WHEN rn = 27 THEN stc_course_name END) AS Cours27,
    MAX(CASE WHEN rn = 28 THEN stc_course_name END) AS Cours28, 
    MAX(CASE WHEN rn = 29 THEN stc_course_name END) AS Cours29,
    MAX(CASE WHEN rn = 30 THEN stc_course_name END) AS Cours30,
    MAX(CASE WHEN rn = 31 THEN stc_course_name END) AS Cours31,
    MAX(CASE WHEN rn = 32 THEN stc_course_name END) AS Cours32,
    MAX(CASE WHEN rn = 33 THEN stc_course_name END) AS Cours33,
    MAX(CASE WHEN rn = 34 THEN stc_course_name END) AS Cours34,
    MAX(CASE WHEN rn = 35 THEN stc_course_name END) AS Cours35,
    MAX(CASE WHEN rn = 36 THEN stc_course_name END) AS Cours36,
    MAX(CASE WHEN rn = 37 THEN stc_course_name END) AS Cours37,
    MAX(CASE WHEN rn = 38 THEN stc_course_name END) AS Cours38,
    MAX(CASE WHEN rn = 39 THEN stc_course_name END) AS Cours39,
    MAX(CASE WHEN rn = 40 THEN stc_course_name END) AS Cours40,
    MAX(CASE WHEN rn = 41 THEN stc_course_name END) AS Cours41,
    MAX(CASE WHEN rn = 42 THEN stc_course_name END) AS Cours42,
    MAX(CASE WHEN rn = 43 THEN stc_course_name END) AS Cours43,
    MAX(CASE WHEN rn = 44 THEN stc_course_name END) AS Cours44,
    MAX(CASE WHEN rn = 45 THEN stc_course_name END) AS Cours45
FROM NumberedCourses
GROUP BY stc_person_id
ORDER BY stc_person_id;