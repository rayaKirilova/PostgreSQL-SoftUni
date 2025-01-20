-- 0 --
create database restaurant ;

-- 01. Departments Info (by id) --
select department_id, count(id) from employees
group by department_id
order by department_id ;

-- 02. Departments Info by Salary --
select department_id, count(salary) from employees
group by department_id
order by department_id ;

-- 03. Sum Salaries per Department --
select department_id, sum(salary) from employees
group by department_id
order by department_id ;

-- 04. Maximum Salary --
select department_id, max(salary) from employees
group by department_id
order by department_id ;

-- 05. Minimum Salary per Department --
select department_id, min(salary) from employees
group by department_id
order by department_id ;

-- 06. Average Salary --
select department_id, avg(salary) from employees
group by department_id
order by department_id ;

-- 07. Filter Total Salaries --
select department_id, sum(salary) as total_salary from employees
group by department_id
having sum(salary) < 4200
order by department_id ;

-- 08. Department Names --
select id, first_name, last_name, round(salary, 2), department_id,
    case
        when department_id = 1 then 'Management'
        when department_id = 2 then 'Kitchen Staff'
        when department_id = 3 then 'Service Staff'
    else 'Other'
    end as department_name
 from employees ;


