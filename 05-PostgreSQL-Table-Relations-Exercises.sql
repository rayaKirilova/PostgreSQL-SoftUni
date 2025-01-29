-- 0 --
CREATE DATABASE table_relations ;

-- 01. Primary Key --

-- 01.1. Create a Table --
CREATE TABLE products (
    product_name VARCHAR(100)
) ;

INSERT INTO products (product_name)
VALUES ('Broccoli'),
       ('Shampoo'),
       ('Toothpaste'),
       ('Candy');


-- 01.2. Define the primary key when changing the existing table structure --
ALTER TABLE products
ADD COLUMN id SERIAL PRIMARY KEY ;


-- 02. Remove Primary Key --
ALTER TABLE products
DROP CONSTRAINT products_pkey ;


-- 03. Customs --

-- 03.1. Create and Insert Passports Table --
CREATE TABLE IF NOT EXISTS passports(
	id INT GENERATED ALWAYS AS IDENTITY (START WITH 100 INCREMENT 1) PRIMARY KEY,
	nationality VARCHAR(50)
);

INSERT INTO passports  (nationality)
VALUES ('N34FG21B'),
       ('K65LO4R7'),
       ('ZE657QP2') ;


-- 03.2. Create and Insert People Table --
CREATE TABLE IF NOT EXISTS people (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    salary DECIMAL(10, 2),
    passport_id INT,
    CONSTRAINT fk_people_passports
        FOREIGN KEY(passport_id)
        REFERENCES passports(id)
);

INSERT INTO people (first_name, salary, passport_id)
VALUES ('Roberto', 43300.0000, 101),
       ('Tom', 56100.0000, 102),
       ('Yana', 60200.0000, 100) ;

SELECT p.id, p.first_name, p.salary, ps.id FROM passports ps
    JOIN people p ON ps.id = p.passport_id ;


-- 04. Car Manufacture --

-- 04.1. Create Tables --
CREATE TABLE manufacturers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE models (
    id INT GENERATED ALWAYS AS IDENTITY (START 1000 INCREMENT 1) PRIMARY KEY,
	model_name VARCHAR(50),
    manufacturer_id INT,
     FOREIGN KEY(manufacturer_id)
     REFERENCES manufacturers(id)
);

CREATE TABLE production_years (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    established_on DATE,
    manufacturer_id INT,
     FOREIGN KEY(manufacturer_id)
     REFERENCES manufacturers(id)
) ;

-- 04.2. Insert Data --
INSERT INTO manufacturers(name)
VALUES
    ('BMW'),
    ('Tesla'),
    ('Lada') ;

INSERT INTO models(model_name, manufacturer_id)
VALUES
	('X1', 1),
	('i6', 1),
	('Model S', 2),
	('Model X', 2),
	('Model 3', 2),
	('Nova', 3);

INSERT INTO production_years(established_on, manufacturer_id)
VALUES
	('1916-03-01', 1),
	('2003-01-01', 2),
	('1966-05-01', 3);


-- 06. Photo Shooting --
CREATE TABLE customers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(30),
    date DATE
);

CREATE TABLE photos (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    url TEXT,
    place VARCHAR(50),
    customer_id INT REFERENCES customers
);

INSERT INTO customers(name, date)
VALUES
    ('Bella', '2022-03-25'),
    ('Philip', '2022-07-05');

INSERT INTO photos (url, place, customer_id)
VALUES ('bella_1111.com',	'National Theatre',	1),
       ('bella_1112.com',	'Largo',	1),
       ('bella_1113.com',	'The View Restaurant',	1),
       ('philip_1121.com',	'Old Town',	2),
       ('philip_1122.com',	'Rowing Canal',	2),
       ('philip_1123.com',	'Roman Theater',	2);


-- 08. Study Session --
CREATE TABLE students (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_name VARCHAR(30)

) ;

CREATE TABLE exams (
    id INT GENERATED ALWAYS AS IDENTITY (START 101 INCREMENT 1) PRIMARY KEY,
    exam_name VARCHAR(50)
) ;

CREATE TABLE study_halls (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    study_hall_name VARCHAR(100),
    exam_id INT REFERENCES exams
) ;

CREATE TABLE students_exams (
    student_id INT REFERENCES students,
    exam_id INT REFERENCES exams
) ;

INSERT INTO students (student_name)
VALUES ('Mila'),
       ('Toni'),
       ('Ron') ;

INSERT INTO exams (exam_name)
VALUES ('Python Advanced'),
       ('Python OOP'),
       ('PostgreSQL') ;

INSERT INTO study_halls (study_hall_name, exam_id)
VALUES ('Open Source Hall', 102),
       ('Inspiration Hall', 101),
       ('Creative Hall', 103),
       ('Masterclass Hall', 103),
       ('Information Security Hall', 103);

INSERT INTO students_exams(student_id, exam_id)
VALUES (1, 101),
       (1, 102),
       (2, 101),
       (3, 103),
       (2, 102),
       (2, 103) ;


-- 10. Online Store --
CREATE DATABASE online_store_db ;

CREATE TABLE cities (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city_name VARCHAR(50)
) ;

CREATE TABLE customers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_name VARCHAR(50),
    birthday DATE ,
    city_id INT REFERENCES cities
) ;

CREATE TABLE orders (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT REFERENCES customers
) ;

CREATE TABLE item_types (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_type_name VARCHAR(50)
) ;

CREATE TABLE items (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_name VARCHAR(50),
    item_type_id INT REFERENCES item_types
) ;

CREATE TABLE order_items (
    order_id INT REFERENCES orders,
    item_id INT REFERENCES items
) ;


-- 11. Delete Cascade --

CREATE DATABASE tbl_rel_geography_db ;

ALTER TABLE countries
ADD CONSTRAINT fk_countries_continents
    FOREIGN KEY (continent_code)
    REFERENCES continents(continent_code)
    ON DELETE CASCADE ;

ALTER TABLE countries
ADD CONSTRAINT fk_countries_currencies
    FOREIGN KEY (currency_code)
    REFERENCES currencies(currency_code)
    ON DELETE CASCADE ;


-- 12. Update Cascade --

ALTER TABLE countries_rivers
ADD CONSTRAINT fk_countries_rivers_rivers
    FOREIGN KEY  (river_id)
    REFERENCES rivers(id)
    ON UPDATE CASCADE ,

ADD CONSTRAINT fk_countries_rivers_countries
    FOREIGN KEY  (country_code)
    REFERENCES countries(country_code)
    ON UPDATE CASCADE ;


-- 13. Set NULL --
CREATE TABLE customers(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_name VARCHAR(30)
);

CREATE TABLE contacts (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contact_name VARCHAR(30),
    phone VARCHAR(30),
    email VARCHAR(30),
    customer_id INT,
    FOREIGN KEY (customer_id)
    REFERENCES customers(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

INSERT INTO customers(customer_name)
VALUES
	('BlueBird Inc'),
	('Dolphin LLC');

INSERT INTO contacts(customer_id, contact_name, phone, email)
VALUES
	(1,'John Doe','(408)-111-1234','john.doe@bluebird.dev'),
    (1,'Jane Doe','(408)-111-1235','jane.doe@bluebird.dev'),
    (2,'David Wright','(408)-222-1234','david.wright@dolphin.dev');

DELETE FROM
customers
WHERE id = 1;

SELECT * FROM customers cst
    JOIN contacts c ON cst.id = c.customer_id ;


-- 14. Peaks in Rila --

SELECT mn.mountain_range, pk.peak_name, pk.elevation FROM mountains mn
    JOIN peaks pk ON mn.id = pk.mountain_id
WHERE mn.mountain_range = 'Rila'
ORDER BY pk.elevation DESC ;


-- 15. Countries Without Any Rivers --

SELECT COUNT(c.id) FROM countries c
    LEFT JOIN countries_rivers ctr ON c.country_code = ctr.country_code
WHERE ctr.country_code IS NULL ;


