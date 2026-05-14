select distinct
    insta_person_id
    ,p.last_name AS "High School"
    ,insta_year_attend_end
   FROM 
    custom_insights.institutions_attend_view
left outer JOIN 
    years_attended ON years_attended.institutions_attend_id = custom_insights.institutions_attend_view.institutions_attend_id
left outer JOIN 
    institutions ON custom_insights.institutions_attend_view.insta_institutions_id = institutions.institutions_id
left outer  JOIN 
    person pa ON insta_person_id = pa.id
left outer join  
    person p ON insta_institutions_id = p.id
LEFT OUTER JOIN 
    address ON pa.preferred_address = address.address_id
LEFT OUTER JOIN 
    address_ls a1 ON address.address_id = a1.address_id AND a1.pos = 1 AND a1.address_lines IS NOT NULL
LEFT OUTER JOIN 
    address_ls a2 ON address.address_id = a2.address_id AND a2.pos = 2 AND a2.address_lines IS NOT NULL
LEFT OUTER JOIN 
    perphone p1 ON pa.id = p1.id AND p1.pos = 1
LEFT OUTER JOIN 
    perphone p2 ON pa.id = p2.id AND p2.pos = 2
LEFT OUTER JOIN 
    people_email pe1 ON pa.id = pe1.id AND pe1.person_email_types = 'KC'
LEFT OUTER JOIN 
    people_email pe2 ON pa.id = pe2.id AND pe2.person_email_types = 'PE'
WHERE 
    insta_year_attend_end > '2026' 
    and inst_type IN ('HSPR', 'OTHS', 'HSPB', 'HOSC') 
   









