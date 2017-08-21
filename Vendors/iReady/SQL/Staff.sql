select
	''
		as 'ClientId',
	tch.sc
		as 'SchoolId',
	tch.id
		as 'StaffMemberID_OwnerID',
	replace(tch.tf, ' ', '')
		as 'FirstName',
	replace(tch.te, ' ', '')
		as 'LastName',
	'Teacher'
		as 'Role',
	replace(tch.em, ' ', '')
		as 'Email',
	replace(tch.em, ' ', '')
		as 'UserName',
	'welcome2iready'
		as 'Password',
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
	tch
where
	tch.sc in (
		1
	  , 2
	  , 3
	  , 4
	) and
	tch.tg  = '' and
	tch.id <> '0' and
	tch.del = '0'
