-- 0 --
create database book_library;
-- execute script from file 03-DB-Lab-book_library.sql --

-- 01. Find Book Titles --
select title from books
where title like 'The%'
order by id ;

-- 02. Replace Titles --
select replace(title, 'The', '***') from books
where title like 'The%'
order by id ;

-- 03. Triangles on Bookshelves --
select id, (side * height)/2 as area from triangles
order by id ;

-- 04. Format Costs --
select title, round(cost, 3) as modified_price from books
order by id ;

-- 05. Year of Birth --
select first_name, last_name, extract(year from born) as year from authors ;

-- 06. Format Date of Birth --
select last_name as "Last Name", to_char(born, 'DD (Dy) Mon YYYY') AS "Date of Birth" from authors ;

-- 07. Harry Potter Books --
select title from books
where title like '%Harry Potter%'
order by id;