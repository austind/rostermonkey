select
	'2017'
		as 'SCHOOLYEAR',
	cast(crs.cn as varchar) + '-' + cast(mst.se as varchar)
		as 'CLASSLOCALID',
	mst.se
		as 'COURSEID',
    crs.co
		as 'COURSENAME',
	null
		as 'COURSESUBJECT',
	replace(
	replace(
	replace(
	replace(
	replace(
			crs.co, '/', '-'),
					'&', 'and'),
					',', '-'),
					'(', ''),
					')', '')
	+ ' - ' + cast(mst.pd as varchar) + 
	case
		when mst.pd = 1 then 'st'
		when mst.pd = 2 then 'nd'
		when mst.pd = 3 then 'rd'
		else 'th'
	end
	+ ' Period - ' + cast(mst.se as varchar)
		as 'CLASSNAME',
	crs.de
		as 'CLASSDESCRIPTION',
	mst.pd
		as 'CLASSPERIOD',
	'MDR'
		as 'ORGANIZATIONTYPEID',
    case
		-- Set correct school codes for your instance
		when mst.sc = 1 then ''		-- Primary
		when mst.sc = 2 then ''		-- Elementary
		when mst.sc = 3 then ''		-- Middle
		when mst.sc = 4 then ''		-- High
	end
		as 'ORGANIZATIONID',
	crs.lo
		as 'GRADE',
	null
		as 'TERMID',
	'MYHRW'
		as 'HMHAPPLICATIONS'
from
	crs left join mst on
			crs.cn = mst.cn
where
	(
		(
			crs.s1 in (
				'B',
				'L'											-- Math
			) or
			crs.s2 in (
				'B',
				'L'
			) or
			crs.s3 in (
				'B',
				'L'
			) or 
			(crs.cn = 'G02106' and mst.se = '228')			-- Peer assisted learning
		)
		or
		(
			mst.sc = 4 and
			crs.co like '%Math%'
		)
	) and
	mst.sc in (1,2,3,4) and
	mst.del = 0 and 
	crs.del = 0
order by 
	mst.sc,
	crs.de,
	mst.se,
	mst.pd,
    mst.hi