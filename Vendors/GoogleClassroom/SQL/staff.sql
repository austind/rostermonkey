-- https://support.google.com/a/answer/6032762
select
	min(sc)
		as 'school_id',
	min(id)
		as 'staff_id',
	tf
		as 'first_name',
	tln
		as 'last_name',
	min(em)
		as 'user_name'
from
	tch
where
	sc in (1,2,3,4) and
	id <> 0 and
	em <> '' and
	del = 0 and
	tg = ''
group by
	id,
	tf,
	tln
order by
	min(sc),
	tln,
	tf