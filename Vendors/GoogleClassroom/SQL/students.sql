-- https://support.google.com/a/answer/6032762
-- All this min() nonsense is to make sure no duplicate student IDs are returned.
-- Apparently, there are duplicate IDs in the STU table, and I can't seem to figure
-- out how to tell TSQL to only return the first student ID row without wrapping
-- everything in min().
select
	min(sc)
		as 'school_id',
	min(id)
		as 'student_id',
	min(fn)
		as 'first_name',
	min(ln)
		as 'last_name',
	min(gr)
		as 'grade_level',
	cast(min(id) as varchar) + '@example.org'
		as 'user_name'
from
	stu
where
	gr != -1 and
	sc in (1,2,3,4) and
	del = 0 and
	tg = ''
group by
	id
order by
	min(sc),
	min(gr),
	min(ln),
	min(fn)