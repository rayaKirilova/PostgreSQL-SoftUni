-- 0 --
create database softuni_management_db;
-- execute script from file 02-DB-Exercise-softuni-management_db

-- 01. Select Cities --
select * from cities
order by id;

-- 02. Concatenate --
select name || ' ' || state as "cities_information", area as "area_km2" from cities ;

-- 03. Remove Duplicate Rows --
select distinct(name), area as "area_km2" from cities
order by name desc;

-- 04. Limit Records --
select id, first_name || ' ' || last_name as "full_name", job_title from employees
order by first_name
limit 50;

-- 05. Skip Rows --
select id as "id", first_name || ' ' || middle_name || ' ' || last_name as "full_name", hire_date from employees
order by id, hire_date asc
offset 9 ;

-- 06. Find the Addresses --
select id, number || ' '  || street as "address", city_id from addresses
where id >= 20 ;

-- 07. Positive Even Number --
select concat(number, ' ', street) as address, city_id from addresses
where city_id > 0 and city_id % 2 = 0
order by city_id asc ;

-- 08. Projects within a Date Range --
select name, start_date, end_date from projects
where start_date >= '2016-06-01 07:00:00'
and end_date < '2023-06-04 00:00:00'
order by start_date asc;

-- 09. Multiple Conditions --
select number, street from addresses
where id between 50 and 100
or number < 1000 ;

-- 10. Set of Values --
select employee_id, project_id from employees_projects
where employee_id in (200, 250)
and project_id not in (50, 100);

-- 11. Compare Character Values --
select name, start_date from projects
where name in ('Mountain', 'Road', 'Touring')
limit 20;

-- 12. Salary --
select concat(first_name, ' ', last_name) as full_name, job_title, salary from employees
where salary in (12500, 14000, 23600, 25000)
order by salary desc;

-- 13. Missing Value --
select id, first_name, last_name from employees
where middle_name is null
order by id
limit 3;

-- 14. Insert Departments --
insert into departments(department, manager_id)
values 	('Finance', 3),
	('Information Services', 42),
	('Document Control', 90),
	('Quality Assurance', 274),
	('Facilities and Maintenance', 218),
	('Shipping and Receiving', 85),
	('Executive', 109);
select * from departments;

-- 15 New Table
create table company_chart as
    select concat(first_name, ' ', last_name) as full_name, job_title, department_id, manager_id
    from employees;
select * from company_chart;

-- 16. Update the Project End Date --
update projects
set end_date = start_date + interval '5 months'
where end_date is null;

-- 17. Award Employees with Experience --
select * from employees
where hire_date between '1998-01-01' and '2000-01-05';

update employees
set salary = salary + 1500, job_title = concat('Senior ', job_title)
where hire_date between '1998-01-01' and '2000-01-05';

-- 18. Delete Addresses --
select * from addresses
where city_id in (5, 17, 20, 30);

delete
from addresses
where city_id in (5, 17, 20, 30);

-- 19. Create a View --
create view view_company_chart as
    select full_name, job_title from company_chart
    where manager_id = 184 ;

-- 20. Create a View with Multiple Tables --
create view view_addresses as
    select distinct(concat(emp.first_name, ' ', emp.last_name)) as full_name,
           emp.department_id, concat(adr.number, ' ', adr.street) as address
    from employees emp
    join addresses adr on emp.address_id = adr.id
order by address;

-- 21. Alter View --
alter view view_addresses
rename to view_employee_addresses_info ;

-- 22. Drop View --
drop view view_company_chart ;

-- 23. Upper --
select name from projects
where id in (1, 158);

update projects
set name = upper(name);

-- 24. Substring --
create view view_initials as
    select substring(first_name from 1 for 2) as initial, last_name from employees
    order by last_name;

-- 25. Like --
select name, start_date from projects
where name like 'MOUNT%'
order by id;