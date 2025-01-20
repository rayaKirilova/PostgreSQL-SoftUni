-- 0 --
create database hotel;
-- execute 02-DB-Lab-hotel_db.sql --

-- 01. Select Employee Information --
select id, first_name || ' ' || last_name AS "Full Name", job_title as "Job Title" from employees;

-- 02. Select Employees by Filtering --
select id, first_name || ' ' || last_name AS "full_name", job_title as "job_title", salary from employees
where salary > 1000
order by id;

-- 03. Select Employees by Multiple Filters --
select id, first_name,  last_name, job_title, department_id, salary from employees
where department_id = 4
and salary >= 1000
order by id
;

-- 04. Insert Data into Employees Table --
insert into employees (first_name, last_name, job_title, department_id, salary)
values ('Samantha', 'Young', 'Housekeeping', 4, 900),
       ('Roger', 'Palmer', 'Waiter', 3, 928.33)
;
select * from employees;

-- 05. Update Salary and Select --
update employees
set salary = salary + 100
where job_title = 'Manager'
;
select * from employees
where job_title = 'Manager';

-- 06. Delete from Table --
delete
from employees
where department_id in (1, 2)
;
select * from employees
-- where department_id in (1, 2)
order by id ;

-- 07. Top Paid Employee View --
select * from employees
order by salary desc
limit 1;

create view top_paid_employee as
    select * from employees
    order by salary desc
    limit 1;

select * from top_paid_employee;
