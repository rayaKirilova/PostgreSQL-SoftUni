-- 0 --
CREATE DATABASE soft_uni ;

-- 01. Towns Addresses --

SELECT t.town_id, t.name, a.address_text FROM towns t
            JOIN addresses a ON t.town_id = a.town_id
WHERE t.town_id IN (9, 15, 32)
ORDER BY t.town_id, a.address_id ;

-- 02. Managers --

SELECT emp.employee_id, CONCAT(emp.first_name, ' ', emp.last_name) AS full_name, dp.department_id,
dp.name AS department_name FROM employees emp
    RIGHT JOIN departments dp ON emp.employee_id = dp.manager_id
ORDER BY emp.employee_id
LIMIT 5 ;


-- 03. Employees’ Projects --

SELECT emp.employee_id, CONCAT(emp.first_name, ' ', emp.last_name) AS full_name,
ep.project_id, pr.name AS project_name
FROM employees_projects ep
        JOIN employees emp ON ep.employee_id = emp.employee_id
         JOIN projects pr ON ep.project_id = pr.project_id
WHERE ep.project_id = 1 ;


-- 04. Higher Salary --

SELECT COUNT(employee_id) FROM employees
WHERE salary >
      (SELECT AVG(salary) FROM employees );

