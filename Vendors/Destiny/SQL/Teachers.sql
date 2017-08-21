select
	sc  as 'SchoolCode',
	id  as 'Id',
	tf  as 'FirstName',
	tln as 'LastName',
	em  as 'Email'
from
	tch
where
	sc in (1,2,3,4) and
	tg = ' ' and
	id <> '0' and
	del = '0'
order by
	sc,
	tln,
	tf