-- http://static.typingclub.com/m/corp2/other/data-import-typingclub.pdf
select * from (
-- Elementary
select
	tch.id
		as 'class-id',
	tch.id
		as 'instructor-id',
	tch.sc
		as 'school-id',
	tch.tln
		as 'name',
	tch.tf + ' ' + tch.tln + ' - Room ' + tch.rm
		as 'description',
	tch.hi
		as 'grade',
	'update'
		as 'action'
from
	tch
where
	tch.sc = 2 and
	tch.id <> 0 and
	tch.del = 0
union all
-- Middle
select
	mst.se
		as 'class-id',
	tch.id
		as 'instructor-id', 
	tch.sc
		as 'school-id',
	crs.co + ' - ' + tch.tf + ' ' + tch.tln + ' - Period ' + cast(mst.pd as varchar)
		as 'name',
	crs.de + ' - ' + tch.tf + ' ' + tch.tln + ' - Period ' + cast(mst.pd as varchar)
		as 'description',
	crs.hi
		as 'grade',
	'update'
		as 'action'
from
	crs
		left join mst on
			crs.cn = mst.cn
		left join tch on
			mst.tn = tch.tn and mst.sc = tch.sc
where
	mst.sc = 3
	mst.del = 0 and 
	crs.del = 0 and
	tch.del = 0
) Classes
order by
	'school-id',
	'name'