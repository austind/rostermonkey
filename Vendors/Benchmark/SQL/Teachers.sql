select distinct
	loc.nm
		as 'School Name',
	replace(tch.em, ' ', '')
		as 'Username',
	tch.id
		as "Teacher's SIS Id",
	replace(tch.tf, ' ', '')
		as 'First Name',
	replace(tch.te, ' ', '')
		as 'Last Name',
	-- lowercase first initial, lowercase last initial, teacher ID#
	lower(substring(tch.tf, 1, 1)) +
	lower(substring(tch.te, 1, 1)) +
	cast(tch.id as varchar)
		as 'Password',
	replace(tch.em, ' ', '')
		as 'Email',
	'What is the first performance you attended?'
		as 'Security Question',
	'The Nutcracker Suite'
		as 'Security Answer'
from
	stu left join tch on
		stu.cu = tch.tn and stu.sc = tch.sc
		left join loc on
		stu.sc = loc.cd
where
	tch.sc in (
		1
	  , 2
	  , 3
	  , 4
	) and
	tch.tg  = '' and
	tch.id <> '0' and
	tch.del = '0'
order by
	1,
	5,
	4