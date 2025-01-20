-- 0 --
create database minions_db;

-- 01. Create a Table --
create table public.minions(
    id serial primary key,
    name varchar(30),
    age int
);

-- 02. Rename the Table --
alter table  minions
rename to minions_info
;

-- 03. Alter the Table --
alter table minions_info
add column code character(4),
add column task text,
add column salary numeric(8, 3)
;

-- 04. Rename Column --
alter table minions_info
rename column salary to banana
;

-- 05. Add New Columns --
alter table minions_info
add column email varchar(20),
add column equipped  boolean default false not null
;

-- 06. Create ENUM Type --
create type type_mood as enum ('happy', 'relaxed', 'stressed', 'sad');
alter table minions_info
add column mood type_mood;

-- 07. Set Default --
alter table minions_info
alter column age set default 0,
alter column name set default '',
alter column code set default ''
;

-- 08. Add Constraints --
alter table minions_info
add constraint unique_constraint unique (id, email),
add constraint banana_check check (banana > 0)
;

-- 09. Change Column’s Data Type --
alter table minions_info
alter column task type varchar(150);

-- 10. Drop Constraint --
alter table minions_info
alter column equipped drop not null;

-- 11. Remove Column --
alter table minions_info
drop column age;

-- 12. Table Birthdays --
create table minions_birthdays(
    id serial primary key not null,
    name varchar(50),
    date_of_birth date,
    age int,
    present varchar(100),
    party timestamptz

);

-- 13. Insert Into --
insert into minions_info (name, code, task, banana, email, equipped, mood)
values
('Mark', 'GKYA', 'Graphing Points', 3265.265, 'mark@minion.com', false, 'happy'),
('Mel', 'HSK', 'Science Investigation', 54784.996, 'mel@minion.com', true, 'stressed'),
('Bob',	'HF',	'Painting',	35.652, 'bob@minion.com',	true, 'happy'),
('Darwin',	'EHND',	'Create a Digital Greeting',	321.958	,'darwin@minion.com',	false,	'relaxed'),
('Kevin',	'KMHD',	'Construct with Virtual Blocks',	35214.789,	'kevin@minion.com',false, 'happy'),
('Norbert',	'FEWB',	'Testing',	3265.500,	'norbert@minion.com',	true,	'sad'),
('Donny',	'L',	'Make a Map',	8.452,	'donny@minion.com',	true,	'happy');

-- 14. Select --
select name, task, email, banana  from minions_info ;

-- 15. Truncate the Table --
truncate table minions_info;

-- 16. Drop the Table --
drop table minions_birthdays;

-- 17 Delete the Database --
drop database minions_db;