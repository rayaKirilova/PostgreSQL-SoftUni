-- 01. INSERT --

insert into addresses (street, town, country, account_id)
select username, password, ip, age from accounts a
where gender = 'F';


-- 02. UPDATE --

update addresses
set country = 'Blocked'
where substring(country, 1, 1) = 'B';

update addresses
set country = 'Test'
where substring(country, 1, 1) = 'T';

update addresses
set country = 'In Progress'
where substring(country, 1, 1) = 'P';


-- 03. DELETE --

--select *
delete
from addresses
where id % 2 = 0
and street like '%r%'