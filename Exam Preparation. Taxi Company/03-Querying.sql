
-- 01. Cars --

SELECT make, model, condition FROM cars
ORDER BY id ASC ;


-- 02. Drivers and Cars --

SELECT d.first_name, d.last_name, c.make, c.model, c.mileage FROM drivers d
    INNER JOIN cars_drivers cd ON d.id = cd.driver_id
    INNER JOIN cars c ON c.id = cd.car_id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name ASC ;


-- 03. Number of Courses for Each Car --

SELECT c.id AS car_id, c.make, c.mileage, COUNT(cr.id) AS count_of_courses, ROUND(AVG(cr.bill), 2) AS average_bill
FROM courses cr
    FULL OUTER JOIN cars c ON cr.car_id = c.id
GROUP BY c.id, c.make, c.mileage
HAVING COUNT(cr.id) <> 2
ORDER BY count_of_courses DESC, c.id ASC ;


-- 04. Regular Clients --

SELECT c.full_name, COUNT(cr.car_id) AS count_of_cars, SUM(cr.bill) AS total_sum FROM courses cr
    INNER JOIN clients c ON cr.client_id = c.id
WHERE SUBSTRING(c.full_name, 2, 1) = 'a'
GROUP BY c.full_name, cr.client_id
HAVING COUNT(cr.car_id) > 1
ORDER BY c.full_name ASC ;


-- 05. Full Information of Courses --

SELECT a.name AS address,
       CASE
        WHEN EXTRACT(HOUR FROM start) BETWEEN 6 AND 20 THEN 'Day'
        WHEN EXTRACT(HOUR FROM start) >= 21 OR EXTRACT(HOUR FROM start) < 6 THEN 'Night'
       END AS day_time,
       cr.bill, c.full_name, crs.make, crs.model, ct.name AS category_name FROM clients c
    INNER JOIN courses cr ON c.id = cr.client_id
    INNER JOIN addresses a ON cr.from_address_id = a.id
    INNER JOIN cars crs ON crs.id = cr.car_id
    INNER JOIN categories ct ON ct.id = crs.category_id
ORDER BY cr.id ;
