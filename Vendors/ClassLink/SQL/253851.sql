-- Benchmark Universe
select
	cast(stu.id as varchar) + '@example.org'
		as 'adusername',
	cast(stu.id as varchar) + '@example.org'
		as "input[name='username']",
	lower(substring(stu.fn, 1, 1)) +
	lower(substring(stu.ln, 1, 1)) +
	cast(stu.id as varchar)
		as "input[name='password']"
from
	stu
where
	stu.sc in (
		1,
		2,
		3,
		4
	) and
	stu.del = 0  and
	stu.tg  = ''
order by
	1