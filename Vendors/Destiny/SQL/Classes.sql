select * from (
-- Student classes
select
	mst.sc
		as 'SchoolCode',
	crs.de
		as 'CourseDesc',
	crs.cn
		as 'CourseNo',
	mst.se
		as 'SectionId',
	tch.id
		as 'TeacherId', 
	mst.pd
		as 'Period',
	secstu.id
		as 'StudentId',
	crs.dc
		as 'Department'
from
	crs left join mst on
		crs.cn = mst.cn
	left join tch on
		mst.tn = tch.tn and mst.sc = tch.sc
	left join (
			select stu.id, sec.sc, sec.se, sec.del
			from  sec 
			left join stu on 
				sec.sn = stu.sn and sec.sc = stu.sc
			where
				stu.tg = '' and
				stu.del = 0 and
				sec.del = 0
			
		) as secstu
on
	mst.se = secstu.se and mst.sc = secstu.sc
where
	mst.sc in (1,2) and
	mst.del = 0 and 
	crs.del = 0 and
	secstu.del = 0 and
	tch.del = 0
union all
-- Prep periods
select 
	mst.sc
		as 'SchoolCode',
	crs.de
		as 'CourseDesc',
	crs.cn
		as 'CourseNo',
	mst.se
		as 'SectionId',
	tch.id
		as 'TeacherId', 
	mst.pd
		as 'Period',
	null
		as 'StudentId',
	crs.dc
		as 'Department'
from mst
	left join crs on
		crs.cn = mst.cn
	left join tch on
		mst.tn = tch.tn and mst.sc = tch.sc
where
	crs.co like '%Prep%' and
	mst.sc in (5) and
	mst.del = 0 and
	crs.del = 0 and
	tch.del = 0
) Classes
order by 
	'SchoolCode',
	'Period',
	'CourseDesc',
	'StudentId'