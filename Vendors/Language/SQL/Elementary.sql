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
	stu
where
	stu.sc = 2 and
	stu.gr in (
		4,
		5
	) and
	stu.del = '0' and
	stu.tg = ''
order by
	stu.gr, stu.ln, stu.fn