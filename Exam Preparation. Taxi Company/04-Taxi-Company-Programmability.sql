-- 01. Find all Courses by Client’s Phone Number --

CREATE OR REPLACE FUNCTION fn_courses_by_client(phone_num VARCHAR(20))
RETURNS INT
AS
$$
    DECLARE num_courses INT ;
    BEGIN
        select count(cr.id) INTO num_courses
        from clients cl
            inner join courses cr on cl.id = cr.client_id
        where phone_num = cl.phone_number;
        RETURN num_courses ;
    END;
$$
LANGUAGE plpgsql ;

select count(cr.id) from clients cl
    inner join courses cr on cl.id = cr.client_id
where phone_number = '(704) 2502909' ;

select fn_courses_by_client('(704) 2502909') ;
select fn_courses_by_client('(831) 1391236') ;


-- 02. Full Info for Address --

-- Stored Procedure which return the results as a table:
CREATE TABLE search_results (
    id SERIAL PRIMARY KEY,
    address_name VARCHAR(50),
    full_name VARCHAR(100),
    level_of_bill VARCHAR(20),
    make VARCHAR(30),
    condition CHAR(1),
    category_name VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE sp_courses_by_address(address_name VARCHAR(100))
LANGUAGE plpgsql
AS $$
BEGIN
    -- Clear previous results from the table
    TRUNCATE TABLE search_results;

    -- Insert new results into the table
    INSERT INTO search_results (address_name, full_name, level_of_bill, make, "condition", category_name)
    SELECT
		a.name, cl.full_name,
           CASE
               WHEN cou.bill <= 20 THEN 'Low'
               WHEN cou.bill <= 30 THEN 'Medium'
               ELSE 'High'
           END AS level_of_bill,
           c.make, c."condition",cat."name"
    FROM courses cou
        INNER JOIN addresses AS a ON cou.from_address_id = a."id"
        INNER JOIN clients AS cl ON cou.client_id = cl.id
        INNER JOIN cars AS c ON cou.car_id = c.id
        INNER JOIN categories AS cat ON c.category_id = cat.id
    WHERE a."name" = address_name
    ORDER BY c.make, cl.full_name;
END;
$$;

CALL sp_courses_by_address('66 Thompson Drive') ;
CALL sp_courses_by_address('700 Monterey Avenue');

SELECT * FROM search_results;


