-- Geography_DB Part --
-- 0 --
CREATE DATABASE geography_db ;
-- execute script FROM file 03-DB-Exercises-geography_db.sql


-- 01. River Info --
CREATE view view_river_info AS
    SELECT CONCAT('The river', ' ', river_name, ' ', 'flows into the', ' ', outflow, ' ', 'and is', ' ', "LENGTH", ' ', 'kilometers long.')
    AS "River Information" FROM rivers
    ORDER BY river_name ASC ;


-- 02. Concatenate Geography Data --
CREATE VIEW view_continents_countries_currencies_details AS
    SELECT CONCAT(TRIM(cnt.continent_name), ': ', cnt.continent_code) AS continent_details,
           CONCAT(ctr.country_name, ' - ', ctr.capital, ' - ', ctr.area_in_sq_km, ' - km2') AS country_information,
           CONCAT(crc.description, ' (', crc.currency_code, ')') AS currencies
    FROM continents cnt
        JOIN countries ctr ON cnt.continent_code = ctr.continent_code
        JOIN currencies crc ON ctr.currency_code = crc.currency_code
    ORDER BY country_information, currencies ;


-- 03. Capital Code --
ALTER TABLE countries
ADD COLUMN capital_code varchar(2) ;

UPDATE countries
SET capital_code = SUBSTRING(capital FROM 1 FOR 2);

SELECT * FROM countries ;


-- 04. Description --
SELECT SUBSTRING(description FROM 5 FOR LENGTH(description)) AS "substring" FROM currencies;


-- 05. Substring River Length --
 SELECT SUBSTRING("River Information" FROM '([0-9]{1,4})') FROM view_river_info ;


-- 06. Replace A --
SELECT REPLACE(mountain_range, 'a', '@') AS replace_a,
       REPLACE(mountain_range, 'A', '$') AS replace_A FROM mountains ;


-- 07. Translate --
SELECT capital, TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS translated_name FROM countries ;


-- 08. Leading --
SELECT continent_name, TRIM(LEADING FROM continent_name) AS "trim" FROM continents ;


-- 09. Trailing --
SELECT continent_name, TRIM(TRAILING FROM continent_name) AS "trim" FROM continents ;


-- 10. LTRIM & RTRIM --
SELECT TRIM(LEADING 'M' FROM peak_name) AS left_trim, trim(TRAILING 'm' FROM peak_name) AS right_trim FROM peaks ;


-- 11. Character Length and Bits --
SELECT CONCAT(mnt.mountain_range, ' ', pks.peak_name) AS mountain_information,
       LENGTH(CONCAT(mnt.mountain_range, ' ', pks.peak_name)) AS characters_length,
       bit_LENGTH(CONCAT(mnt.mountain_range, ' ', pks.peak_name)) AS bits_of_a_tring
FROM mountains mnt
    INNER JOIN peaks pks ON mnt.id = pks.mountain_id ;


-- 12. Length of a Number --
SELECT population, LENGTH(CAST(population AS text)) AS "length" FROM countries ;


-- 13. Positive and Negative Left --
SELECT peak_name,
    LEFT(peak_name, 4) AS positive_left,
    SUBSTRING(peak_name FOR GREATEST(0, LENGTH(peak_name) - 4)) AS negative_left
FROM peaks;


-- 14. Positive and Negative Right --
SELECT peak_name,
    RIGHT(peak_name, 4) AS positive_right,
    SUBSTRING(peak_name FROM 5) AS negative_right
FROM peaks;


-- 15. UPDATE iso_code --
SELECT country_name, iso_code, UPPER(LEFT(country_name, 3)) AS big FROM countries
WHERE iso_code IS NULL ;
-- 63 rows
UPDATE countries
SET iso_code = UPPER(LEFT(country_name, 3))
WHERE iso_code IS NULL ;


-- 16. Reverse country_code --
UPDATE countries
SET country_code = REVERSE(LOWER(country_code));


-- 17. Elevation --->> Peak Name --
SELECT CONCAT(elevation, ' --->> ', peak_name) AS "Elevation-->>Peak Name" FROM peaks
WHERE elevation >= 4884 ;



-- Booking_DB Part --
-- 0 --
CREATE DATABASE booking_db ;
-- execute script from file 03-DB-Exercises-booking_db.sql


-- 18. Arithmetical Operators --
CREATE TABLE bookings_calculation AS
    SELECT booked_for FROM bookings
    WHERE apartment_id = 93 ;

ALTER TABLE bookings_calculation
ADD COLUMN multiplication NUMERIC,
ADD COLUMN modulo NUMERIC ;

UPDATE bookings_calculation
SET multiplication = booked_for * 50,
    modulo = MOD(booked_for, 50);


-- 19. Round vs Trunc --
SELECT latitude, ROUND(latitude, 2) AS "round", TRUNC(latitude, 2) AS "trunc" FROM apartments ;


-- 20. Absolute Value --
SELECT longitude, ABS(longitude) FROM apartments ;


-- 22. Extract Booked At --
SELECT EXTRACT(YEAR FROM booked_at) AS year,
       EXTRACT(MONTH FROM booked_at) AS month,
       EXTRACT(DAY FROM booked_at) AS day,
       EXTRACT(HOUR FROM booked_at) AS hour,
       EXTRACT(MINUTE FROM booked_at) AS minute,
       ceiling(EXTRACT(SECOND FROM booked_at)) AS second
FROM bookings ;


-- 24. Early Birds --
SELECT user_id, CONCAT(EXTRACT(MONTH FROM age(starts_at, booked_at)), ' mons ',
                       EXTRACT(DAY FROM age(starts_at, booked_at)), ' days ',
                       EXTRACT(HOUR FROM age(starts_at, booked_at)), ':',
                       EXTRACT(MINUTE FROM age(starts_at, booked_at)), ':',
                       ROUND(EXTRACT(SECOND FROM age(starts_at, booked_at)), 3)
                       )
FROM bookings
WHERE EXTRACT(MONTH FROM age(starts_at, booked_at)) >= 10 ;


-- 24. Match or Not --
SELECT companion_full_name, email FROM users
WHERE LOWER(companion_full_name) LIKE '%and%'
AND email NOT LIKE '%@gmail' ;


-- 25. Count by Initial --
SELECT SUBSTRING(first_name,1, 2) AS initials, COUNT(id) AS user_count FROM users
GROUP BY SUBSTRING(first_name, 1, 2)
ORDER BY user_count DESC, initials ;


-- 26. Sum --
SELECT SUM(booked_for) FROM bookings
WHERE apartment_id = 90 ;


-- 27. Average Value --
SELECT AVG(multiplication) FROM bookings_calculation ;