select
	''
		as 'ClientId',
	stu.sc
		as 'SchoolId',
	stu.id
		as 'StudentID_OwnerID',
	stu.id
		as 'StudentNumber',
	stu.fn
		as 'FirstName',
	stu.ln
		as 'LastName',
	case
		when stu.gr = -1 then 0					-- Transitional kindergarten (TK)
		else stu.gr
	end
		as 'Grade',
	cast(stu.id as varchar) + '@example.org'
		as 'UserName',
	lower(substring(stu.fn, 1, 1)) +
	lower(substring(stu.ln, 1, 1)) +
	cast(stu.id as varchar)
		as 'Password',
	convert(varchar(10), stu.bd, 101)
		as 'DOB',
	case
		when stu.rc1 = 100				 then 1	-- Native American
		when stu.rc1 between 200 and 299 then 2 -- Asian
		when stu.rc1 = 400				 then 2	-- Asian
		when stu.rc1 between 300 and 399 then 4 -- Hawaiian / Pacific Islander
		when stu.rc1 = 600				 then 3	-- Black
		when stu.rc1 = 700				 then 5	-- White
		else 6
	end
		as 'Ethnicity',
	case
		when stu.eth = 'y' then 'true'
		else 'false'
	end
		as 'Hispanic',
	case
		when stu.sx = 'M' then 'Male'
		when stu.sx = 'F' then 'Female'
	end
		as 'Gender',
    case
		isnull((
			select min(cd)
			from fre
			where esd = (
				select max(esd)
				from fre
				where
					id = stu.id and
					del = 0 and
					esd <= current_timestamp
			)
			and id = stu.id
		),'')
		when ''  then 'false'					-- Not economically disadvantaged
		when 'f' then 'true'					-- Eligible for free lunches
		when 'r' then 'true'					-- Eligible for reduced lunches
		else 'false'							-- Unknown
	end
		as 'EconomicallyDisadvantaged',
	case
		when stu.lf = 1 then 'false'			-- English (Primary)
		when stu.lf = 2 then 'false'			-- Initially Fluent English Proficient (English second language, but fluent)
		when stu.lf = 3 then 'true'				-- English Learner
		when stu.lf = 4 then 'false'			-- Redesignated Fluent English Proficient (later determined fluent)
		when stu.lf = 5 then 'true'				-- To Be Determined
		else 'false'
	end
		as 'EnglishLearner',
	case
		when stu.id in (
			select id
			from cse							-- Special education table
			where cse.del = 0
		) then 'true'
		else 'false'
	end
		as 'SpecialEducation',
	case
		when stu.id in (
			select pid
			from pgm
			where pgm.cd = '135'				-- Migrant ed
			and pgm.del = 0
		) then 'true'
		else 'false'
	end
		as 'Migrant',
	null
		as 'MathDevelopmentalLevel',
	null
		as 'EnglishDevelopmentalLevel',
	null
		as 'PartnerId',
	null
		as 'Action',
	null
		as 'RTI Level',
	null
		as 'Gifted/Talented',
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
    stu
where
	stu.sc in (
		1										-- Primary
	  , 2										-- Elementary
	  , 3										-- Middle
	  , 4										-- High
	) and
	stu.del = '0' and
	stu.tg = ''
order by
	'Grade'
  , 'LastName'
  , 'FirstName'