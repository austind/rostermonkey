select * from (
-- McKinley / Wilson
select distinct
	''
		as 'ClientId',
	tch.id
		as 'StaffId',
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
	tch
where
	tch.sc in (
		1		-- Primary
	  , 2		-- Secondary
	) and
	tch.id <> 0 and
	tch.del = 0
union all
-- Middle / High
select distinct
	''
		as 'ClientId',
	tch.id
		as 'StaffId',
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
	mst left join tch on
			mst.tn = tch.tn and mst.sc = tch.sc
		inner join crs on
			mst.cn = crs.cn
where
	mst.del = 0 and 
	crs.del = 0
) Roster
order by
	2