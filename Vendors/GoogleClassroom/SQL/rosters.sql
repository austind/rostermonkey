-- https://support.google.com/a/answer/6032762
select * from (
-- Primary / Elementary
select
	stu.sc
		as 'school_id',
	tch.id
		as 'class_id',
	cast(stu.id as varchar) + '@example.org'
		as 'student_id'
from
	stu
		left join tch on
			stu.cu = tch.tn and tch.sc = 2
where
	stu.sc in (1,2) and
	tch.id <> 0 and
	stu.del = 0 and
	stu.tg = ''
union all
-- Middle / High
select distinct
	stu.sc
		as 'school_id',
	mst.se
		as 'class_id',
	cast(stu.id as varchar) + '@example.org'
		as 'student-id'
from
	sec left join stu on 
			sec.sn = stu.sn and sec.sc = stu.sc
		left join mst on
			sec.se = mst.se and sec.sc = mst.sc
		inner join crs on
			mst.cn = crs.cn
where
	stu.sc in (3,4) and
	crs.co not in (
		'Prep',
		'Teachers Aide',
		'Tchr Aide',
		'Office Aide',
		'Snack Bar Aide'
	) and
	stu.del = 0   and
	stu.tg  = ' ' and
	mst.del = 0   and
	sec.del = 0
) students
order by
	'school_id',
	'class_id'