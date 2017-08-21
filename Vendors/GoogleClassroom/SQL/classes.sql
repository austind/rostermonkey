-- https://support.google.com/a/answer/6032762
select * from (
-- Primary / Elementary
select
	tch.sc
		as 'school_id',
	cast(tch.id as varchar)
		as 'class_id',
	tch.tln
		as 'course_name',
	tch.tf + ' ' + tch.tln + ' - Room ' + tch.rm
		as 'section_name',
	cast(tch.tln as varchar)
		as 'period_name',
	cast(tch.id as varchar) + '@example.org'
		as 'staff_id'
from
	tch
where
	tch.sc in (1,2) and
	tch.id <> 0 and
	tch.del = 0
union all
-- Middle / High
select
	tch.sc
		as 'school_id',
	cast(mst.cn as varchar) + '-' + cast(mst.se as varchar)
		as 'class_id',
	crs.co
		as 'course_name',
	crs.co + ' - ' + tch.tln + ' - Period ' + cast(mst.pd as varchar) + ' - ' + cast(mst.se as varchar)
		as 'section_name',
	cast(mst.pd as varchar)
		as 'period_name',
	cast(tch.id as varchar) + '@example.org'
		as 'staff_id'
from
	mst
		left join crs on
			crs.cn = mst.cn
		left join tch on
			mst.tn = tch.tn and mst.sc = tch.sc
where
	mst.sc in (3,4) and
	crs.co not in (
		'Prep',
		'Teachers Aide',
		'Tchr Aide',
		'Office Aide',
		'Snack Bar Aide'
	) and
	mst.del = 0 and 
	crs.del = 0 and
	tch.del = 0
) Classes
order by
	'school_id',
	'course_name'