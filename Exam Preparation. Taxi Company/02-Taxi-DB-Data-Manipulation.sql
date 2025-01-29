-- 01. INSERT --

INSERT INTO clients (full_name, phone_number)
VALUES  ('Delaney Stove', CONCAT('(088) 9999', 10*2)),
        ('Ilaire Tomaszewicz', CONCAT('(088) 9999', 11*2)),
       ('Genna Jaquet', CONCAT('(088) 9999', 12*2)),
       ('Carlotta Dykas', CONCAT('(088) 9999', 13*2)),
       ('Viki Oneal', CONCAT('(088) 9999', 14*2)),
       ('Anthe Larne', CONCAT('(088) 9999', 15*2)),
       ('Philip Penwarden', CONCAT('(088) 9999', 16*2)),
       ('Cristi Ravenshear', CONCAT('(088) 9999', 17*2)),
       ('Louie Vogel', CONCAT('(088) 9999', 18*2)),
       ('Roddie Gribben', CONCAT('(088) 9999', 19*2)),
       ('Boyce Briddock', CONCAT('(088) 9999', 20*2));

-- phone number: (088) 9999

-- full name
SELECT * FROM drivers
WHERE id BETWEEN 1 AND 20
ORDER BY id ;


-- 02. UPDATE --

SELECT * FROM cars
WHERE (mileage >= 800000 OR mileage IS NULL)
AND year <= 2010
AND make <> 'Mercedes-Benz' ;
-- 15 rows

UPDATE cars
SET condition = 'C'
WHERE (mileage >= 800000 OR mileage IS NULL)
AND year <= 2010
AND make <> 'Mercedes-Benz' ;


-- 03. DELETE --

DELETE
FROM clients
WHERE id IN (SELECT c.id FROM clients c
                FULL OUTER JOIN courses cr ON c.id = cr.client_id
                WHERE cr.client_id IS NULL
                AND LENGTH(full_name) > 3) ;

