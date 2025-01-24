-- Part One: Gringotts DB --
-- 0 --
CREATE DATABASE gringotts_db ;


-- 01. COUNT of Records --
SELECT count(id) AS count FROM wizard_deposits ;


-- 02. Total Deposit Amount --
SELECT SUM(deposit_amount) AS total_amount FROM wizard_deposits ;


-- 03. AVG Magic Wand Size --
SELECT ROUND(AVG(magic_wand_size), 3) AS average_magic_wand_size FROM wizard_deposits ;


-- 04. MIN Deposit Charge --
SELECT MIN(deposit_charge) AS minimum_deposit_charge FROM wizard_deposits ;


-- 05. MAX Age --
SELECT MAX(age) AS maximum_age FROM wizard_deposits ;


-- 06. GROUP BY Deposit Interest --
SELECT deposit_group, SUM(deposit_interest) AS deposit_interest FROM wizard_deposits
GROUP BY deposit_group
ORDER BY deposit_interest DESC ;


-- 07. LIMIT the Magic Wand Creator --
SELECT magic_wand_creator, min(magic_wand_size) AS minimum_wand_size FROM wizard_deposits
GROUP BY magic_wand_creator
ORDER BY minimum_wand_size
LIMIT 5 ;


-- 08. Bank Profitability --
SELECT deposit_group, is_deposit_expired, floor(avg(deposit_interest)) AS deposit_interest FROM wizard_deposits
WHERE deposit_start_date >= '1985-01-01'
GROUP BY deposit_group, is_deposit_expired
ORDER BY deposit_group DESC, is_deposit_expired ;


-- 09. Notes with Dumbledore --
SELECT last_name, COUNT(notes) FROM wizard_deposits
WHERE notes LIKE '%Dumbledore%'
GROUP BY last_name ;


-- 10. Wizard View --
CREATE VIEW view_wizard_deposits_with_expiration_date_before_1983_08_17 AS
       SELECT CONCAT(first_name, ' ', last_name) AS wizard_name,
       deposit_start_date AS start_date,
       deposit_expiration_date AS expiration_date,
       deposit_amount AS amount
    FROM wizard_deposits
    WHERE deposit_expiration_date <= '1983-08-17'
    GROUP BY wizard_name, start_date, expiration_date, amount
    ORDER BY expiration_date ASC;


-- 11. Filter Max Deposit --
SELECT magic_wand_creator, MAX(deposit_amount) AS max_deposit_amount FROM wizard_deposits
GROUP BY magic_wand_creator
HAVING MAX(deposit_amount) < 20000
OR MAX(deposit_amount) > 40000
ORDER BY max_deposit_amount DESC
LIMIT 3 ;


-- 12. Age Group --
SELECT
    CASE
        WHEN age BETWEEN  11 AND 20 THEN '[11-20]'
        WHEN age BETWEEN  21 AND 30 THEN '[21-30]'
        WHEN age BETWEEN  31 AND 40 THEN '[31-40]'
        WHEN age BETWEEN  41 AND 50 THEN '[41-50]'
        WHEN age BETWEEN  51 AND 60 THEN '[51-60]'
    ELSE '[61+]'
    END AS age_group,
    COUNT(*) FROM wizard_deposits
GROUP BY age_group
ORDER BY age_group ASC;


-- Part Two: SoftUni Management DB --
CREATE DATABASE data_aggregation_softuni_management_db ;


-- 13. Sum The Employees
SELECT
	COUNT(CASE WHEN department_id = 1 THEN 1 END) AS "Engineering",
	COUNT(CASE WHEN department_id = 2 THEN 1 END) AS "Tool Design",
	COUNT(CASE WHEN department_id = 3 THEN 1 END) AS "Sales",
	COUNT(CASE WHEN department_id = 4 THEN 1 END) AS "Marketing",
	COUNT(CASE WHEN department_id = 5 THEN 1 END) AS "Purchasing",
	COUNT(CASE WHEN department_id = 6 THEN 1 END) AS "Research and Development",
	COUNT(CASE WHEN department_id = 7 THEN 1 END) AS "Production"
FROM
	employees


-- 14. Update Employees' Data
UPDATE employees
SET
    salary = CASE
                WHEN hire_date < '2015-01-16' THEN salary + 2500
                WHEN hire_date < '2020-03-04' THEN salary + 1500
                ELSE salary
             END,
    job_title = CASE
                    WHEN hire_date < '2015-01-16' THEN CONCAT('Senior', ' ', job_title)
                    WHEN hire_date < '2020-03-04' THEN CONCAT('Mid-', job_title)
                    ELSE job_title
                END ;
              --  RETURNING *


-- 15. Categorizes Salary
SELECT job_title,
       CASE
         WHEN AVG(salary) > 45800 THEN 'Good'
         WHEN AVG(salary) BETWEEN 27500 AND 45800 THEN 'Medium'
         WHEN AVG(salary) < 27500 THEN 'Need Improvement'
       END AS "category"
FROM employees_copy
GROUP BY job_title
ORDER BY category, job_title ;


-- 16. Where Project Status
SELECT project_name,
       CASE
           WHEN start_date IS NULL AND end_date IS NULL THEN 'Ready for development'
           WHEN start_date IS NOT NULL AND end_date IS NULL THEN 'In Progress'
           ELSE 'Done'
       END AS project_status
FROM projects
WHERE project_name LIKE '%Mountain%' ;


-- 17. Having Salary Level
SELECT
	department_id, COUNT(department_id) AS num_employees,
	CASE
		WHEN AVG(salary) > 50000 THEN 'Above average'
		ELSE 'Below average'
	END
FROM employees_copy
GROUP BY department_id
HAVING AVG(salary) > 30000
ORDER BY department_id ASC ;


-- 18. Nested CASE Conditions
CREATE VIEW view_performance_rating AS
SELECT first_name, last_name, job_title, salary, department_id,
	CASE
		WHEN salary >= 25000 THEN
			CASE
				WHEN job_title LIKE 'Senior%' THEN 'High-performing Senior'
				ELSE 'High-performing Employee'
			END
		ELSE 'Average-performing'
	END AS performance_rating
FROM employees_copy ;


-- 19. Foreign Key --
CREATE TABLE employees_projects (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id INT,
    project_id INT,

    FOREIGN KEY (employee_id)
    REFERENCES employees(id),

    FOREIGN KEY (project_id)
    REFERENCES projects(id)
) ;


-- 20. JOIN Tables --
SELECT * FROM departments dp
    JOIN employees_copy emp ON emp.department_id = dp.id
