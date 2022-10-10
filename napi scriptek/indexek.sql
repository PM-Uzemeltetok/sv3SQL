use adventureworks;

explain select * from contact;

select * from contact;

select * from contact
where firstname like 'Jam%';

select * from contact
-- where contactID = 344 
;

select *
from contact force INDEX(IX_HAFirstnameDesc)
where firstname like 'be%'
	 -- and passwordhash like '0d%'
-- order by firstname, passwordhash;
order by firstname;

create index IX_HAindex2 on contact (firstname, passwordhash);
create index IX_HAFirstnameDesc ON contact (firstname desc);
create index IX_HAfirstname ON contact (firstname);
drop index IX_HAfirstname on contact;

SHOW INDEXES FROM contact IN adventureworks;
SHOW INDEXES FROM adventureworks.salesorderheader;
SHOW KEYS FROM contact in adventureworks;

ANALYZE TABLE Bookings;
SHOW TABLE STATUS;
OPTIMIZE TABLE Bookings;