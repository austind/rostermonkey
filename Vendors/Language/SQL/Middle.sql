select
	'Example Middle School'
		as 'SchoolName',
	tch.te
		as 'ClassName',
	tch.id
		as 'ClassID',
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
		inner join tch on 
			tch.tn = mst.tn and tch.sc = mst.sc
where
	stu.del = 0 and
	stu.tg = '' and
	tch.del = 0 and
	tch.tg = ''
order by
	'ClassName',
	'StudentGrade',
	'StudentLastName',
	'StudentFirstName'