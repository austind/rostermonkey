select distinct
	id
		as 'Student ID',
	cast(id as varchar) + '@example.org'
		as 'Username',
	cast(id as varchar) + '@example.org'
		as 'E-Mail',
	'1'
		as 'Enable',
	null
		as 'Temp Password'
from stu
where
	sc in (1, 2, 3, 4) and
	tg = '' and
	del = '0'
order by
	id