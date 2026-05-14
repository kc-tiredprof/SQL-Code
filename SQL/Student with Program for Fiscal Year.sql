select distinct 
spv.stpr_student
,STPR_STATUS
,STPR_START_DATE
,STPR_END_DATE
from 
students_ls 
left outer  join custom_insights.student_programs_view spv on students_id = stpr_student and stu_acad_programs = stpr_acad_program  
left outer join stpr_statuses on spv.student_programs_id = stpr_statuses.student_programs_id and stpr_statuses.pos = '1' 
left outer  join stpr_dates on spv.student_programs_id = stpr_dates.student_programs_id and stpr_dates.pos = '1' 
left outer join person on stpr_student = id 
left outer join person_ls pls on person.id = pls.id
where ((stpr_status = 'G' and stpr_end_date > '2025-07-01'and stpr_start_date < '2026-04-01'and spv.stpr_acad_program like 'DNTA%') OR
 (STPR_STATUS = 'A' and STPR_START_DATE < '2026-04-30' and (STPR_END_DATE > '2025-05-30' or STPR_END_DATE is null) and spv.stpr_acad_program like 'DNTA%')
or (STPR_STATUS IN ('C','W') and STPR_START_DATE < '2026-04-30' and STPR_END_DATE > '2025-06-30') and spv.stpr_acad_program like 'DNTA%')
AND SPV.STPR_STUDENT in 
(Select distinct stc_person_id
FROM STUDENT_ACAD_CRED SAC 
    INNER JOIN STC_STATUSES SS ON SAC.STUDENT_ACAD_CRED_ID = SS.STUDENT_ACAD_CRED_ID and POS=1
	LEFT OUTER JOIN GRADES ON STC_VERIFIED_GRADE = GRADES_ID 
	INNER JOIN PERSON ON STC_PERSON_ID =  PERSON.ID 
WHERE (STC_STATUS IN ('A','N') OR (STC_STATUS = 'D' AND GRD_GRADE = 'W'))
and stc_term in ('2025SU', '2025FA', '2026SP'))


