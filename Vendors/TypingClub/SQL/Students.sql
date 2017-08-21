-- http://static.typingclub.com/m/corp2/other/data-import-typingclub.pdf
select * from (
-- Elementary students
select
	stu.id
		as 'student-id',
	tch.id
		as 'class-id',
	stu.sc
		as 'school-id',
	stu.fn
		as 'first-name',
	stu.ln
		as 'last-name',
	cast(stu.id as varchar) + '@example.org'
		as 'username',
	null
		as 'password',
	cast(stu.id as varchar) + '@example.org'
		as 'email',
	case
		when stu.gr = -1 OR stu.gr = 0 then 'K'
		else stu.gr
	end
		as 'grade',
	'update'
		as 'action'
from
	stu
		left join tch on
			stu.cu = tch.tn and tch.sc = 2
where
	stu.sc = 2 and
	tch.id <> 0 and
	stu.del = 0 and
	stu.tg = ''
union all
-- Middle students
select distinct
	stu.id
		as 'student-id',
	mst.se
		as 'class-id',
	stu.sc
		as 'school-id',
	stu.fn
		as 'first-name',
	stu.ln
		as 'last-name',
	cast(stu.id as varchar) + '@example.org'
		as 'username',
	null
		as 'password',
	cast(stu.id as varchar) + '@example.org'
		as 'email',
	case
		when stu.gr = -1 or stu.gr = 0 then 'K'
		else stu.gr
	end
		as 'grade',
	'update'
		as 'action'
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
	stu.sc = 5
	stu.del = 0 and
	stu.tg = ' ' and
	mst.del = 0 and
	tch.del = 0 and
	sec.del = 0
) students
order by
	'school-id',
	'class-id',
	'grade',
	'last-name',
	'first-name'