Select DISTINCT
STC_PERSON_ID
,  CASE WHEN
        	SUM(stc_cum_contrib_grade_pts) > 0 AND SUM(stc_cum_contrib_gpa_cred) > 0
	        THEN CAST(ROUND(SUM(stc_cum_contrib_grade_pts) / SUM(stc_cum_contrib_gpa_cred), 4) AS DECIMAL(10,3))
    	    ELSE 0
	    END
,age('2026-10-17', person.birth_date)
,case when person.gender = 'M' then 'Male'
when person.gender = 'F' then 'Female' else 'Unknown' end as "Gender"
,CASE 
	WHEN MAX(PLS.POS) OVER (PARTITION BY PLS.ID) > '1' THEN 'Two or More Races'
	ELSE
		CASE 
			WHEN PER_RACES = '1' THEN 'Asian'
			WHEN PER_RACES = '2' THEN 'American Indian/Alaskan Native'
			WHEN PER_RACES = '3' THEN 'Black or African American'
			WHEN PER_RACES = '4' THEN 'Hispanic or Latino'
			WHEN PER_RACES = '5' THEN 'White'
			WHEN PER_RACES = '6' THEN 'Nonresident Alien'
			WHEN PER_RACES = '7' THEN 'Hawaiian/Pacific Islander'
			WHEN PER_RACES = '8' THEN 'Unknown'
			END
	END "Race"
FROM STUDENT_ACAD_CRED SAC 
    INNER JOIN STC_STATUSES SS ON SAC.STUDENT_ACAD_CRED_ID = SS.STUDENT_ACAD_CRED_ID and POS=1
	LEFT OUTER JOIN GRADES ON STC_VERIFIED_GRADE = GRADES_ID 
	INNER JOIN PERSON  ON STC_PERSON_ID =  PERSON.ID
	INNER JOIN PERSON_LS PLS on PLS.ID = PERSON.ID
LEFT OUTER JOIN ADDRESS ON PERSON.PREFERRED_ADDRESS = ADDRESS.ADDRESS_ID
     LEFT OUTER JOIN ADDRESS_LS a1 ON ADDRESS.ADDRESS_ID = A1.ADDRESS_ID AND A1.POS = 1 AND A1.ADDRESS_LINES IS NOT NULL
     LEFT OUTER JOIN ADDRESS_LS a2 ON ADDRESS.ADDRESS_ID = A2.ADDRESS_ID AND A2.POS = 2 AND A2.ADDRESS_LINES IS NOT NULL
     LEFT OUTER JOIN PERPHONE p1 ON PERSON.ID = P1.ID AND P1.POS = 1
     LEFT OUTER JOIN PERPHONE p2 ON PERSON.ID = P2.ID AND P2.POS = 2
     LEFT OUTER JOIN PEOPLE_EMAIL PE1 ON PERSON.ID = PE1.ID AND PE1.PERSON_EMAIL_TYPES = 'KC'
	 LEFT OUTER JOIN PEOPLE_EMAIL PE2 ON PERSON.ID = PE2.ID AND PE2.PERSON_EMAIL_TYPES = 'PE'
	 left outer join cs_2026 on cs_student_id = person.id
WHERE 
 PER_RACES IS NOT null
 and stc_verified_grade_date IS NOT NULL
        AND stc_cred_type <> 'NC'
        and stc_acad_level = 'UG'
 and stc_person_id in 
 (

)
  group by stc_person_id, person.birth_date, person.gender, person.id, pLS.pos, per_races, PLS.ID