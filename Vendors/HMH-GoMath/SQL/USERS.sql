-- http://downloads.hmlt.hmco.com/Help/ImportMngmt/Administrator/SFF_Template_Files/USERS_File.htm
select * from (
-- Students
select
	'2017'
		as 'SCHOOLYEAR',
	'S'
		as 'ROLE',
	stu.id
		as 'LASID',
	stu.cid
		as 'SASID',
	stu.fn
		as 'FIRSTNAME',
	stu.mn
		as 'MIDDLENAME',
	stu.ln
		as 'LASTNAME',
	case
		when stu.gr = -1 then 'TK'
		when stu.gr =  0 then 'K'
		else cast(stu.gr as varchar)
	end
		as 'GRADE',
	cast(stu.id as varchar) + '@example.org'
		as 'USERNAME',
	lower(substring(stu.fn, 1, 1)) +
	lower(substring(stu.ln, 1, 1)) +
	cast(stu.id as varchar)
		as 'PASSWORD',
	'MDR'
		as 'ORGANIZATIONTYPEID',
    case
		when stu.sc = 1 then '00052481'		-- Primary
		when stu.sc = 2 then '00052508'		-- Elementary
		when stu.sc = 3 then '00052493'		-- Middle
		when stu.sc = 4 then '00052534'		-- High
	end
		as 'ORGANIZATIONID',
	null
		as 'PRIMARYEMAIL',
	'MYHRW'
		as 'HMHAPPLICATIONS'
from
    stu
where
	stu.sc in (3,4) and
	stu.del = '0' and
	stu.tg = ''
-- Teachers
union all
select
	'2017'
		as 'SCHOOLYEAR',
	'T'
		as 'ROLE',
	tch.id
		as 'LASID',
	null
		as 'SASID',
	tch.tf
		as 'FIRSTNAME',
	null
		as 'MIDDLENAME',
	tch.te
		as 'LASTNAME',
	case
		when tch.lo != tch.hi then cast(tch.lo as varchar) + '-' + cast(tch.hi as varchar)
		when tch.sc = 4 and tch.lo = 0 and tch.hi = 0 then '9-12'
		when tch.sc = 3 and tch.lo = 0 and tch.hi = 0 then '6-8'
		when tch.sc = 2 and tch.lo = 0 and tch.hi = 0 then '2-5'
		when tch.sc = 1 and tch.lo = 0 and tch.hi = 0 then 'PK-1'
		else null
	end
		as 'GRADE',

	replace(tch.em, ' ', '')
		as 'USERNAME',
	null
		as 'PASSWORD',
	'MDR'
		as 'ORGANIZATIONTYPEID',
    case
		when stu.sc = 1 then '00052481'		-- Primary
		when stu.sc = 2 then '00052508'		-- Elementary
		when stu.sc = 3 then '00052493'		-- Middle
		when stu.sc = 4 then '00052534'		-- High
	end
		as 'ORGANIZATIONID',
	replace(tch.em, ' ', '')
		as 'PRIMARYEMAIL',
	'MYHRW'
		as 'HMHAPPLICATIONS'
from
	tch
where
	sc in (3,4) and 
	tg = '' and
	id <> '0' and
	del = '0'
) Users
order by
	ROLE,
	LASTNAME,
	FIRSTNAME