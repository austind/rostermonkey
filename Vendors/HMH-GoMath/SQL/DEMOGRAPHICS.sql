select
	'2017'
		as 'SCHOOLYEAR',
	stu.id
		as 'LASID',
	stu.sx
		as 'GENDER',
	convert(varchar(10), stu.bd, 101)
		as 'DOB',
	case
		when stu.eth = 'y'			     then 6			-- Hispanic / Other
		when stu.rc1 = 100				 then 1			-- Native American
		when stu.rc1 between 200 and 299 then 2		-- Asian
		when stu.rc1 = 400				 then 2			-- Asian
		when stu.rc1 between 300 and 399 then 4		-- Hawaiian / Pacific Islander
		when stu.rc1 = 600				 then 3			-- Black
		when stu.rc1 = 700				 then 5			-- White
		else 0
	end
		as 'RACE',
	stu.eth
		as 'ISHISPANIC',
	case
		when stu.id in (
			select pid
			from pgm
			where pgm.cd = '135'						-- Migrant ed
			and pgm.del = 0
		) then '4'
		else '0'
	end
		as 'SPECIALSERVICES',
	stu.lf
		as 'ENGLISHPROFICIENCY',
	case
		(
			select di
			from cse
			where cse.id = stu.id
			and cse.del = 0
		)
		when '210' then '4'						-- Developmental Delay
		when '220' then '5'						-- Hearing Impairment
		when '230' then '5'						-- Hearing Impairment
		when '240' then '10'						-- Speech and Language Disorders
		when '260' then '9'						-- Emotional Disturbance
		when '270' then '6'						-- Orthopedic Impairment
		when '280' then '12'						-- Other
		when '290' then '11'						-- Specific Learning Disabilities
		when '310' then '7'						-- Multiple
		when '320' then '1'						-- Autism
		else '0'									-- None
	end
		as 'SPECIALCONDITIONS',
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
		when ''  then 1							-- Not economically disadvantaged
		when 'f' then 2							-- Eligible for free lunches
		when 'r' then 3							-- Eligible for reduced lunches
		else 0										-- Unknown
	end
		as 'ECONOMICSTATUS'
from
    stu
where
	stu.sc in (3,4) and
	stu.del = '0' and
	stu.tg = ''
order by
	stu.gr,
	stu.ln,
	stu.fn