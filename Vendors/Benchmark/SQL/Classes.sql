select * from (
-- Teachers
select distinct
	loc.nm
		as 'School Name',
	replace(tch.tf, ' ', '') + ' ' + replace(tch.te, ' ', '')
		as 'Class Name',
	tch.id
		as "Class's SIS Id",
	tch.em
		as 'Username',
	'Educator'
		as 'User Type'
from
	--tch left join loc on
	--	tch.sc = loc.cd
	-- This way selects only teachers that have students enrolled in them
	stu left join tch on
		stu.cu = tch.tn and stu.sc = tch.sc
		left join loc on
		stu.sc = loc.cd
where
	tch.sc in (
		1,
		2,
		3,
		4
	) and
	tch.del = 0 and
	tch.tg  = '' and
	tch.id <> ''
union all
-- Students
select
	loc.nm
		as 'School Name',
	replace(tch.tf, ' ', '') + ' ' + replace(tch.te, ' ', '')
		as 'Class Name',
	tch.id
		as "Class's SIS Id",
	cast(stu.id as varchar) + '@example.org'
		as 'Username',
	'Learner'
		as 'User Type'
from
	stu left join tch on
		stu.cu = tch.tn and stu.sc = tch.sc
		left join loc on
		stu.sc = loc.cd
where
	stu.sc in (
		1,
		2,
		3,
		4
	) and
	stu.del = 0 and
	stu.tg  = '' and
	tch.id <> ''
) Classes
order by
	1,
	2,
	3