-- 01. Count Employees by Town --

CREATE FUNCTION fn_count_employees_by_town(town_name VARCHAR(20))
RETURNS INT
AS
$$
    DECLARE e_count INT;
        BEGIN
            SELECT COUNT(employee_id) INTO e_count
            FROM employees AS e
                JOIN addresses AS a ON a.address_id = e.address_id
                JOIN towns AS t ON t.town_id = a.town_id
            WHERE t.name = town_name;
            RETURN e_count;
        END;
$$
LANGUAGE plpgsql ;

select fn_count_employees_by_town('Berlin') ;


-- 02. Employees Promotion --

CREATE PROCEDURE sp_increase_salaries(department_name varchar(50))
LANGUAGE plpgsql
AS
$$
    BEGIN
        UPDATE employees AS e
        SET salary = salary * 1.05
        WHERE e.department_id = (
            SELECT department_id FROM departments WHERE name = department_name);
    END;
$$ ;

call sp_increase_salaries('Marketing') ;
call sp_increase_salaries('Research and Development') ;


-- 03. Employees Promotion by ID --

CREATE PROCEDURE sp_increase_salary_by_id(id INT)
LANGUAGE plpgsql
AS
$$
    BEGIN
        IF (SELECT COUNT(employee_id) FROM employees WHERE employee_id = id) != 1 THEN
            ROLLBACK ;
        ELSE
            UPDATE employees
            SET salary = salary * 1.05
            WHERE employee_id = id;
        END IF ;
        COMMIT ;
    END;
$$ ;

call sp_increase_salary_by_id(42) ;

select * from employees
where employee_id = 42 ;


-- 04. Triggered --

CREATE TABLE deleted_employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    middle_name VARCHAR(20),
    job_title VARCHAR(50),
    department_id INT,
    salary NUMERIC(19, 4)
) ;

CREATE FUNCTION trigger_fn_on_employee_delete()
   RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
    BEGIN
     INSERT INTO deleted_employees (first_name,last_name, middle_name,job_title,department_id,salary)
     VALUES(OLD.first_name,OLD.last_name,OLD.middle_name, OLD.job_title,OLD.department_id,OLD.salary);
        RETURN NULL;
    END;
$$ ;

CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
EXECUTE FUNCTION trigger_fn_on_employee_delete() ;