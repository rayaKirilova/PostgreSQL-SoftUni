-- 0 --
CREATE DATABASE book_library;
-- execute script FROM file 03-DB-Lab-book_library.sql --


-- 01. Find Book Titles --
SELECT title FROM books
WHERE title LIKE 'The%'
ORDER BY id ;


-- 02. Replace Titles --
SELECT REPLACE(title, 'The', '***') FROM books
WHERE title LIKE 'The%'
ORDER BY id ;


-- 03. Triangles on Bookshelves --
SELECT id, (side * height)/2 AS area FROM triangles
ORDER BY id ;


-- 04. Format Costs --
SELECT title, ROUND(cost, 3) AS modified_price FROM books
ORDER BY id ;


-- 05. Year of Birth --
SELECT first_name, last_name, EXTRACT(YEAR FROM born) AS "year" FROM authors ;


-- 06. Format Date of Birth --
SELECT last_name AS "Last Name", TO_CHAR(born, 'DD (Dy) Mon YYYY') AS "Date of Birth" FROM authors ;


-- 07. Harry Potter Books --
SELECT title FROM books
WHERE title LIKE '%Harry Potter%'
ORDER BY id;