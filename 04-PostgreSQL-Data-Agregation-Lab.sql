-- 0 --
CREATE DATABASE restaurant ;

-- 01. Departments Info (by id) --
SELECT department_id, COUNT(id) FROM employees
GROUP BY department_id
ORDER BY department_id ;


-- 02. Departments Info by Salary --
SELECT department_id, COUNT(salary) FROM employees
GROUP BY department_id
ORDER BY department_id ;


-- 03. Sum Salaries per Department --
SELECT department_id, SUM(salary) FROM employees
GROUP BY department_id
ORDER BY department_id ;


-- 04. Maximum Salary --
SELECT department_id, MAX(salary) FROM employees
GROUP BY department_id
ORDER BY department_id ;


-- 05. Minimum Salary per Department --
SELECT department_id, MIN(salary) FROM employees
GROUP BY department_id
ORDER BY department_id ;


-- 06. Average Salary --
SELECT department_id, AVG(salary) FROM employees
GROUP BY department_id
ORDER BY department_id ;


-- 07. Filter Total Salaries --
SELECT department_id, SUM(salary) AS total_salary FROM employees
GROUP BY department_id
HAVING SUM(salary) < 4200
ORDER BY department_id ;


-- 08. Department Names --
SELECT id, first_name, last_name, ROUND(salary, 2), department_id,
    CASE
        WHEN department_id = 1 THEN 'Management'
        WHEN department_id = 2 THEN 'Kitchen Staff'
        WHEN department_id = 3 THEN 'Service Staff'
    ELSE 'Other'
    END AS department_name
 FROM employees ;


