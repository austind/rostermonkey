select * from (
-- Primary / Elementary
select distinct
	'ca-gridl81775'
		as 'ClientId',
	stu.id
		as 'StudentId',
	cast(tch.id as varchar)
		as 'SectionId',
	null
		as 'Action',
	null
		as 'Reserved1',
	null
		as 'Reserved2',
	null
		as 'Reserved3',
	null
		as 'Reserved4',
	null
		as 'Reserved5',
	null
		as 'Reserved6',
	null
		as 'Reserved7',
	null
		as 'Reserved8',
	null
		as 'Reserved9',
	null
		as 'Reserved10'
from
	stu
		left join tch on
			stu.cu = tch.tn and stu.sc = tch.sc
where
	stu.sc in (
		1		-- Primary
	  , 2		-- Elementary
	) and
	tch.id <> 0 and
	stu.del = 0 and
	stu.tg = '' and
	tch.del = 0 and
	tch.tg = ''
union all
-- Middle / High
select distinct
	''
		as 'ClientId',
	stu.id
		as 'StudentId',
	cast(crs.cn as varchar) + '-' + cast(mst.se as varchar)
		as 'SectionId',
	null
		as 'Action',
	null
		as 'Reserved1',
	null
		as 'Reserved2',
	null
		as 'Reserved3',
	null
		as 'Reserved4',
	null
		as 'Reserved5',
	null
		as 'Reserved6',
	null
		as 'Reserved7',
	null
		as 'Reserved8',
	null
		as 'Reserved9',
	null
		as 'Reserved10'
from
	sec left join stu on 
			sec.sn = stu.sn and sec.sc = stu.sc
		left join mst on
			sec.se = mst.se and sec.sc = mst.sc
		inner join crs on
			mst.cn = crs.cn
where
	mst.del = 0 and 
	crs.del = 0 and
	sec.del = 0
) Roster
order by
	3