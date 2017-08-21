select * from (
-- Primary / Elementary
select
	''
		as 'ClientId', 		-- i-Ready account ID provided by Curriculum Associates
	tch.sc
		as 'SchoolId',		-- Aeries school code
	cast(tch.id as varchar)
		as 'SectionId',		-- In elementary school, use teacher ID as SectionId
	tch.tf + ' ' + tch.tln +
	case
		when tch.rm <> '' then ' - Room ' + tch.rm
		else null
	end
		as 'Name',			-- Must be unique for schools, e.g. "Jane Doe - Room 11 A"
	null
		as 'Grade',			-- Optional but helpful according to docs
	'Full Year'
		as 'Term',			-- Class is taught all year, no terms in grades 0-6
	null
		as 'Code',			-- Optional
	case
		when tch.rm <> '' then 'Room ' + tch.rm
		else null
	end
		as 'Location',		-- Optional, location of class
	null
		as 'PartnerId',		-- Optional, not applicable here
	null
		as 'Action', 		-- Reserved for future use; leave blank
	tch.tf + ' ' + tch.tln +
	case
		when tch.rm <> '' then ' - Room ' + tch.rm
		else null
	end
		as 'Course',		-- Required if 'Subject' blank. Same as 'Name' here.
	null
		as 'Subject',		-- In grades 0-6, not really applicable
	null
		as 'Reserved1',		-- Reserved for future use; leave blank
	null
		as 'Reserved2',		-- Reserved for future use; leave blank
	null
		as 'Reserved3',		-- Reserved for future use; leave blank
	null
		as 'Reserved4',		-- Reserved for future use; leave blank
	null
		as 'Reserved5',		-- Reserved for future use; leave blank
	null
		as 'Reserved6',		-- Reserved for future use; leave blank
	null
		as 'Reserved7',		-- Reserved for future use; leave blank
	null
		as 'Reserved8'		-- Reserved for future use; leave blank
from
	tch
where
	tch.sc in (
		1					-- Primary
	  , 2					-- Elementary
	) and
	tch.id <> 0 and
	tch.del = 0
union all
-- Middle / High
select
	''
		as 'ClientId',		-- i-Ready account ID provided by Curriculum Associates
	mst.sc
		as 'SchoolId',		-- Aeries school code
	cast(crs.cn as varchar) + '-' + cast(mst.se as varchar)
		as 'SectionId',
	cast(crs.co as varchar) + ' - ' + cast(crs.cn as varchar) + '-' + cast(mst.se as varchar)
		as 'Name',
	crs.lo
		as 'Grade',
	'Full Year'
		as 'Term',
	null
		as 'Code',
	case
		when tch.rm <> '' then 'Room ' + tch.rm
		else null
	end
		as 'Location',
	null
		as 'PartnerId',
	null
		as 'Action',
	crs.co + ' - ' + tch.tf + ' ' + tch.te + ' - Pd. ' + cast(mst.pd as varchar)
		as 'Course',
	case
		when crs.s1 = 'B' then 'Algebra'			-- Maybe only algebra
		when crs.s1 = 'C' then 'Technology'		-- Accounting, keyboarding, web design, agmech
		when crs.s1 = 'D' then 'Drivers Ed'		-- Only coded as drivers ed
		when crs.s1 = 'E' then 'Economics'			-- Only economics
		when crs.s1 = 'F' then 'English'			-- All English / ELD / ELA classes
		when crs.s1 = 'G' then 'Art/For. Language'	-- Mostly art, but also includes Spanish (??)
		when crs.s1 = 'H' then 'Geography'			-- Only geogrphy
		when crs.s1 = 'I' then 'Government'		-- Only government
		when crs.s1 = 'J' then 'Bio-Life Science'	-- Only biology and life sciences
		when crs.s1 = 'K' then 'Life Skills'		-- Healthy/study skills, job readiness, etc.
		when crs.s1 = 'L' then 'Math'				-- Seems mixed: math standards, general math, calculus, etc.
		when crs.s1 = 'M' then 'Phys. Education'	-- P.E., weight training, etc.
		when crs.s1 = 'N' then 'Physical Science'	-- Earth Science, Physics, etc.
		when crs.s1 = 'O' then 'Ag Science'		-- Environmental study, ROP Ag Vet Skills
		when crs.s1 = 'P' then 'U.S. History'		-- U.S. History, AP U.S. History
		when crs.s1 = 'Q' then 'World History'		-- Only world history
		when crs.s1 = 'Z' then 'Miscellaneous'		-- Office aide, Leadership, Study hall, etc.
		else null
	end
		as 'Subject',
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
		as 'Reserved8'
from
	crs
		left join mst on
			crs.cn = mst.cn
		left join tch on
			mst.tn = tch.tn and mst.sc = tch.sc
where
	mst.del = 0 and 
	crs.del = 0
) Classes
order by
	'SchoolId'
  , 'Name'