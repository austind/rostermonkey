select
	loc.nm
		as 'School Name',
	cast(stu.id as varchar) + '@example.org'
		as 'Username',
	stu.id
		as "Student's SIS Id",
	stu.fn
		as 'First Name',
	stu.ln
		as 'Last Name',
	lower(substring(stu.fn, 1, 1)) +
	lower(substring(stu.ln, 1, 1)) +
	cast(stu.id as varchar)
		as 'Password',
	cast(stu.id as varchar) + '@example.org'
		as 'Email',
	'What is the first live performance you attended?'
		as 'Security Question',
	'The Nutcracker Suite'
		as 'Security Answer'
from
	stu left join loc on
		stu.sc = loc.cd
where
	stu.sc in (
		1,
		2,
		3,
		4
	) and
	stu.del = 0  and
	stu.tg  = ''
order by
	'Last Name',
	'First Name'