-- 0 -- create database
create database gamebar;

-- 01. Create Tables --
create table employees(
    id serial primary key not null,
    first_name varchar(30),
    last_name varchar(50),
    hiring_date date default '2023-01-01',
    salary numeric(10,2),
    devices_number int
);
create table departments(
    id serial primary key not null,
    name varchar(50),
    code character(3),
    description text
);
create table issues(
    id serial primary key unique,
    description varchar(150),
    date date,
    start timestamp
);

-- 02. Alter Tables --
alter table employees
add column middle_name varchar(50)
;

-- 03. Add Constraints --
alter table employees
alter column salary set not null,
alter column salary set default 0,
alter column hiring_date set not null
;

-- 04. Modify Columns --
alter table employees
alter column middle_name type varchar(100)
;

-- 05. Truncate Tables --
truncate table issues;

-- 06. Drop Tables --
drop table departments;


