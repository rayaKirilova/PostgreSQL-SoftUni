-- 0 --
CREATE DATABASE hotel;
-- execute 02-DB-Lab-hotel_db.sql --


-- 01. Select Employee Information --
SELECT id, first_name || ' ' || last_name AS "Full Name", job_title AS "Job Title" FROM employees;

SELECT id, CONCAT(first_name, ' ', last_name) AS "Full Name", job_title AS "Job Title" FROM employees;


-- 02. Select Employees by Filtering --
SELECT id, CONCAT(first_name, ' ', last_name) AS full_name, job_title AS job_title, salary FROM employees
WHERE salary > 1000
ORDER BY id;


-- 03. Select Employees by Multiple Filters --
SELECT id, first_name,  last_name, job_title, department_id, salary FROM employees
WHERE department_id = 4
AND salary >= 1000
ORDER BY id
;


-- 04. Insert Data into Employees Table --
INSERT INTO employees (first_name, last_name, job_title, department_id, salary)
VALUES ('Samantha', 'Young', 'Housekeeping', 4, 900),
       ('Roger', 'Palmer', 'Waiter', 3, 928.33)
;
SELECT * FROM employees;


-- 05. Update Salary and Select --
UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager'
;

SELECT * FROM employees
WHERE job_title = 'Manager';


-- 06. Delete from Table --
DELETE
FROM employees
WHERE department_id IN (1, 2)
;

SELECT * FROM employees
WHERE department_id in (1, 2);


-- 07. Top Paid Employee View --
SELECT * FROM employees
ORDER BY salary desc
LIMIT 1;

CREATE VIEW top_paid_employee AS
    SELECT * FROM employees
    ORDER BY salary DESC
    LIMIT 1;

SELECT * FROM top_paid_employee;
