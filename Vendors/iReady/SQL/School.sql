select
	''
		as 'ClientId',
	loc.cd
		as 'SchoolId',
	loc.nm
		as 'SchoolName',
	'Example School District'
		as 'DistrictName',
	'XX'
		as 'State',
	case
		-- https://nces.ed.gov/globallocator/
		when loc.cd = 1 then '' -- Primary
		when loc.cd = 2 then '' -- Elementary
		when loc.cd = 3 then '' -- Middle
		when loc.cd = 4 then '' -- High
		else null
	end
		as 'NCESID',
	null
		as 'PartnerId',
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
	loc
where
	loc.cd in (
		1
	  , 2
	  , 3
	  , 4
	)