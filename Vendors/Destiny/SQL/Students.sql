-- Elementary students
select * from (
select
	stu.sc
		as 'SchoolCode',
	stu.id
		as 'ID',
	stu.ln
		as 'LastName',
	stu.fn
		as 'FirstName',
	stu.gr
		as 'Grade',
	convert(varchar(10), stu.bd, 101)
		as 'Birthday',
	stu.sx
		as 'Gender',
	stu.ad
		as 'Address',
	stu.cy
		as 'City',
	stu.st
		as 'State',
	stu.zc
		as 'ZipCode',
	stu.tl
		as 'Phone',
	tch.te
		as 'HomeroomTeacher',
	null
		as 'ElaTeacher',
	null
		as 'ElaPeriod',
	-- Expected graduation year
	case
		when datepart(month,getdate()) >= 7 then datepart(year,getdate()) + 12 - stu.gr + 1
		else datepart(year,getdate()) + 12 - stu.gr
	end
		as 'GradYear'
from
	stu
		left join tch on
			stu.cu = tch.tn and tch.sc = 2
where
	stu.sc = '2' and
	stu.del = 0 and
	stu.tg = ' '
union all
-- Middle and High School students
select
	stu.sc
		as 'SchoolCode',
	stu.id
		as 'ID',
	stu.ln
		as 'LastName',
	stu.fn
		as 'FirstName',
	stu.gr
		as 'Grade',
	convert(varchar(10), stu.bd, 101)
		as 'Birthday',
	stu.sx
		as 'Gender',
	stu.ad
		as 'Address',
	stu.cy
		as 'City',
	stu.st
		as 'State',
	stu.zc
		as 'ZipCode',
	stu.tl
		as 'Phone',
	tch.te
		as 'HomeroomTeacher',
	ela.te
		as 'ElaTeacher',
	ela.pd
		as 'ElaPeriod',
	case
		when datepart(month,getdate()) >= 7 then datepart(year,getdate()) + 12 - gr + 1
		else datepart(year,getdate()) + 12 - gr
	end
		as 'GradYear'
from
	sec left join stu on 
			sec.sn = stu.sn and sec.sc = stu.sc
		left join mst on
			sec.se = mst.se and sec.sc = mst.sc
		inner join crs on
			mst.cn = crs.cn
		inner join tch on 
			tch.tn = mst.tn and tch.sc = mst.sc
		left join (
			select
				stu.id,
				tch.te,
				mst.pd
			from
				sec left join stu on 
					sec.sn = stu.sn and sec.sc = stu.sc
				left join mst on
					sec.se = mst.se and sec.sc = mst.sc
				left join tch on
					mst.tn = tch.tn and mst.sc = tch.sc
				left join crs on
					mst.cn = crs.cn
			where
				(
					crs.co like '%ELA%' or crs.co like '%English%'
				) and
					crs.co not like '%ELA Support%' and
				(
					stu.sc = 1 or stu.sc = 2
				) and (
					mst.del = 0 and 
					crs.del = 0	and
					tch.del = 0 and
					stu.tg = ' ' and
					stu.del = 0 and
					sec.del = 0
				)
		) as ela on stu.id = ela.id
where
	(
		(
			stu.sc = 1
		)
		or 
		(
			stu.sc = 2
		)
	) and
	(
		stu.del = 0 and
		stu.tg = ' ' and
		mst.del = 0	and 
		crs.del = 0	and
		tch.del = 0 and
		sec.del = 0
	)
) students
order by
	SchoolCode,
	grade,
	FirstName,
	LastName