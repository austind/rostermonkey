select * from (
-- Students
select
	'2017'
		as 'SCHOOLYEAR',
	cast(crs.cn as varchar) + '-' + cast(mst.se as varchar)
		as 'CLASSLOCALID',
	secstu.id
		as 'LASID',
	'S'
		as 'ROLE',
	null
		as 'POSITION'
from
	crs left join mst on
		crs.cn = mst.cn
		left join tch on
			mst.tn = tch.tn and mst.sc = tch.sc
		left join (
				select stu.id, sec.sc, sec.se, sec.del
				from sec 
				left join stu on 
					sec.sn = stu.sn and sec.sc = stu.sc
				where
					stu.tg  = ' ' and
					stu.del = 0   and
					sec.del = 0
			) as secstu
	on
		mst.se = secstu.se and mst.sc = secstu.sc
where
	(
		(
			crs.s1 in (
				'B',
				'L'											-- Math
			) or
			crs.s2 in (
				'B',
				'L'
			) or
			crs.s3 in (
				'B',
				'L'
			) or 
			(crs.cn = 'G02106' and mst.se = '228')			-- Peer assisted learning
		)
		or
		(
			mst.sc = 5 and
			crs.co like '%Math%'
		)
	) and
	mst.sc in (3,4) and
	mst.del    = 0   and
	crs.del    = 0   and
	tch.del    = 0
union all
-- Teachers
select distinct
	'2016'
		as 'SCHOOLYEAR',
	cast(crs.cn as varchar) + '-' + cast(mst.se as varchar)
		as 'CLASSLOCALID',
	tch.id
		as 'LASID',
	'T'
		as 'ROLE',
	'L'
		as 'POSITION'
from
	crs left join mst on
		crs.cn = mst.cn
		left join tch on
			mst.tn = tch.tn and mst.sc = tch.sc
where
	(
		(
			crs.s1 in (
				'B',
				'L'											-- Math
			) or
			crs.s2 in (
				'B',
				'L'
			) or
			crs.s3 in (
				'B',
				'L'
			) or 
			(crs.cn = 'G02106' and mst.se = '228')			-- Peer assisted learning
		)
		or
		(
			mst.sc = 5 and
			crs.co like '%Math%'
		)
	) and
	mst.sc in (3,4) and
	mst.del    = 0   and
	crs.del    = 0   and
	tch.del    = 0   and
	tch.id   <> ''
) ClassAssignment
order by
	ROLE,
	LASID,
	CLASSLOCALID