-- *** There is no way to auto-import students into Language Live,
--     So this just makes seeding initial rosters easier. (they still
--     need to be uploaded by hand)
select
	stu.id
		as 'StudentID',
	stu.ln
		as 'StudentLastName',
	stu.fn
		as 'StudentFirstName',
	convert(varchar(10), stu.bd, 101)
		as 'StudentBirthDate',
	stu.gr
		as 'StudentGrade'
from
	sec left join stu on 
			sec.sn = stu.sn and sec.sc = stu.sc
		left join mst on
			sec.se = mst.se and sec.sc = mst.sc
		inner join crs on
			mst.cn = crs.cn
where
	stu.sc = 4
order by
	stu.gr, stu.ln, stu.fn