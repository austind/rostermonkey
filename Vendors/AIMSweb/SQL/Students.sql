select
	case
		when stu.sc = 1 then 'Example Primary School'
		when stu.sc = 2 then 'Example Elementary School'
		when stu.sc = 3 then 'Example Middle School'
		when stu.sc = 4 then 'Example High School'
	end
		as 'SchoolName',
	stu.fn 
		as 'StudentFirstName',
	stu.mn
		as 'StudentMiddleName',
	stu.ln
		as 'StudentLastName',
	stu.id
		as 'UniqueIdentifier',
	cast(stu.id as varchar) + '@example.org'
		as 'StudentEmail',
	case
		when cast(stu.gr as varchar) = -1 then 'K'						-- Transitional kindergarten (TK)
		when cast(stu.gr as varchar) =  0 then 'K'						-- Kindergarten
		else cast(stu.gr as varchar)
	end
		as 'Grade',
	stu.sx
		as 'Gender',
	convert(varchar(10), stu.bd, 101)
		as 'DOB',
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
		), '')
		when ''  then 'None'					-- Not economically disadvantaged
		when 'f' then 'Free'					-- Eligible for free lunches
		when 'r' then 'Reduced'				-- Eligible for reduced lunches
	end
		as 'MealStatus',
	case
		when stu.eth = 'y' 				 then 'Hispanic'
		when stu.rc1 = 100 				 then 'American Indian/Alaska Native'
		when stu.rc1 between 200 and 299 then 'Asian'
		when stu.rc1 = 400				 then 'Asian'
		when stu.rc1 between 300 and 399 then 'Pacific Islander'
		when stu.rc1 = 600				 then 'African American'
		when stu.rc1 = 700				 then 'White'
	end
		as 'Ethnicity',
	'Example School District'
		as 'DistrictName'
from
    stu
where
	-- Include all school codes defined in select clause
	stu.sc in (1,2,3,4) and
	stu.del = '0' and
	stu.tg = ''
order by
	stu.sc,
	stu.gr,
	stu.ln,
	stu.fn