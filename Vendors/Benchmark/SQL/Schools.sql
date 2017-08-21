select
	loc.nm
		as 'School Name',
	loc.cd
		as "School's SIS Id"
from
	loc
where
	loc.cd in (
		1,
		2,
		3,
		4
	)