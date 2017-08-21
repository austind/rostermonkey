select * from (
-- Kindergarten Students
select
	'Student'
		as 'ROLE',
	cast(stu.id as varchar) + '@example.org'
		as 'USERNAME',
	lower(substring(stu.fn, 1, 1)) +
	lower(substring(stu.ln, 1, 1)) +
	cast(stu.id as varchar)
		as 'PASSWORD',
	stu.ln
		as 'LAST_NAME',
	stu.fn
		as 'FIRST_NAME',
	case
		when stu.mn != '' then substring(stu.mn, 1, 1)
		else null
	end
		as 'MIDDLE_INITIAL',
	stu.sx
		as 'GENDER',
	cast(stu.id as varchar) + '@example.org'
		as 'EMAIL',
	case
		when stu.gr = -1 then 'PK'
		when stu.gr = 0  then 'K'
		else cast(stu.gr as varchar)
	end
		as 'STUDENT_GRADE',
	stu.id
		as 'STUDENT_ID',
	null
		as 'SCHOOL_ZIPCODE',
	null
		as 'SCHOOL_NAME',
	''		-- Master code specific to school and year
		as 'MASTER_CODE',
	'08/01/2017'
		as 'CONTENT_EXPIRY_DATE',
	tch.tf + ' ' + tch.te
		as 'CLASS_NAME',
	null
		as 'CLASS_GRADE',
	tch.em
		as 'STUDENTS_TEACHER_USER_NAME'
from
	stu
		left join tch on
			stu.cu = tch.tn and tch.sc = 1
where
	stu.sc = 1 and
	stu.gr in (
		0
	) and
	stu.tg = '' and
	stu.del = 0 and
	tch.del = 0
union all
-- Middle School Students
select
	'Student'
		as 'ROLE',
	cast(stu.id as varchar) + '@example.org'
		as 'USERNAME',
	lower(substring(stu.fn, 1, 1)) +
	lower(substring(stu.ln, 1, 1)) +
	cast(stu.id as varchar)
		as 'PASSWORD',
	stu.ln
		as 'LAST_NAME',
	stu.fn
		as 'FIRST_NAME',
	case
		when stu.mn != '' then substring(stu.mn, 1, 1)
		else null
	end
		as 'MIDDLE_INITIAL',
	stu.sx
		as 'GENDER',
	cast(stu.id as varchar) + '@example.org'
		as 'EMAIL',
	cast(stu.gr as varchar)
		as 'STUDENT_GRADE',
	stu.id
		as 'STUDENT_ID',
	null
		as 'SCHOOL_ZIPCODE',
	null
		as 'SCHOOL_NAME',
	''		-- Master code specific to school and year
		as 'MASTER_CODE',
	'08/01/2017'
		as 'CONTENT_EXPIRY_DATE',
	tch.te + ' ' + crs.co + ' Period ' + cast(mst.pd as varchar)
		as 'CLASS_NAME',
	null
		as 'CLASS_GRADE',
	tch.em
		as 'STUDENTS_TEACHER_USER_NAME'
from
	mst left join crs on
			crs.cn = mst.cn
		left join tch on
			mst.tn = tch.tn and mst.sc = tch.sc
		left join sec on
			mst.cn = sec.cn and mst.se = sec.se
		left join stu on
			sec.sn = stu.sn and sec.sc = stu.sc
where
	stu.sc = 5 and
	stu.tg = '' and
	stu.del = 0 and
	tch.del = 0 and
	mst.del = 0 and
	sec.del = 0
union all
-- Kindergarten teachers
select distinct
	'Teacher'
		as 'ROLE',
	tch.em
		as 'USERNAME',
	lower(substring(tch.tf, 1, 1)) +
	lower(substring(tch.te, 1, 1)) +
	cast(tch.id as varchar)
		as 'PASSWORD',
	replace(replace(tch.te, '(', ''), ')', '')
		as 'LAST_NAME',
	replace(replace(tch.tf, '(', ''), ')', '')
		as 'FIRST_NAME',
	null
		as 'MIDDLE_INITIAL',
	null
		as 'GENDER',
	tch.em
		as 'EMAIL',
	null
		as 'STUDENT_GRADE',
	null
		as 'STUDENT_ID',
	'95948'
		as 'SCHOOL_ZIPCODE',
	'McKinley'
		as 'SCHOOL_NAME',
	MasterCodeEnumeration.MASTER_CODE
		as 'MASTER_CODE',
	'08/01/2017'
		as 'CONTENT_EXPIRY_DATE',
	tch.tf + ' ' + tch.te
		as 'CLASS_NAME',
	null
		as 'CLASS_GRADE',
	null
		as 'STUDENTS_TEACHER_USER_NAME'
from
	-- Since teachers are not reliably coded into grade levels in Aeries,
	-- we need to infer a teacher's grade level by the grade of the students they teach.
	tch left join stu on
		stu.cu = tch.tn and stu.sc = tch.sc
	cross join
	(
		select '' as MASTER_CODE -- Set appropriate master code
		union all
		select '' as MASTER_CODE -- Set appropriate master code
	) as MasterCodeEnumeration(MASTER_CODE)
where
	tch.sc = 1 and
	stu.gr in (
		0
	) and
	tch.del = 0 and
	tch.id <> 0
union all
-- Middle School teachers
select
	'Teacher'
		as 'ROLE',
	tch.em
		as 'USERNAME',
	lower(substring(tch.tf, 1, 1)) +
	lower(substring(tch.te, 1, 1)) +
	cast(tch.id as varchar)
		as 'PASSWORD',
	replace(replace(tch.te, '(', ''), ')', '')
		as 'LAST_NAME',
	replace(replace(tch.tf, '(', ''), ')', '')
		as 'FIRST_NAME',
	null
		as 'MIDDLE_INITIAL',
	null
		as 'GENDER',
	tch.em
		as 'EMAIL',
	null
		as 'STUDENT_GRADE',
	null
		as 'STUDENT_ID',
	'95948'
		as 'SCHOOL_ZIPCODE',
	'Sycamore'
		as 'SCHOOL_NAME',
	MasterCodeEnumeration.MASTER_CODE
		as 'MASTER_CODE',
	'08/01/2017'
		as 'CONTENT_EXPIRY_DATE',
	tch.te + ' ' + crs.co + ' Period ' + cast(mst.pd as varchar)
		as 'CLASS_NAME',
	null
		as 'CLASS_GRADE',
	null
		as 'STUDENTS_TEACHER_USER_NAME'
from
    mst left join crs on
			crs.cn = mst.cn
		left join tch on
			mst.tn = tch.tn and mst.sc = tch.sc
		cross join
		(
			select '' as MASTER_CODE
			union all
			select '' as MASTER_CODE
		) as MasterCodeEnumeration(MASTER_CODE)
where
       tch.sc = 5 and
       tch.del = 0 and
       mst.del = 0 and
	   tch.id <> 0
) Users
order by
	ROLE,
	STUDENT_GRADE,
	CLASS_NAME,
	LAST_NAME,
	FIRST_NAME