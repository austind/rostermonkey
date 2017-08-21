-- http://static.typingclub.com/m/corp2/other/data-import-typingclub.pdf
select
	id
		as 'instructor-id',
	sc
		as 'school-id',
	tf
		as 'first-name',
	tln
		as 'last-name',
	em
		as 'email',
	null
		as 'phone',
	'welcome'
		as 'password',
	'update'
		as 'action'
from
	tch
where
	sc in (2,3) and
	tg  = '' and
	id <> '0' and
	del = '0'
order by
	sc,
	tln,
	tf