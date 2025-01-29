-- 0 --
CREATE DATABASE subqueries_joins_booking_db ;

-- 01. Booked for Nights --

SELECT CONCAT(a.address, ' ', a.address_2) AS apartment_address,
b.booked_for AS nights
FROM apartments a
    INNER JOIN bookings b ON a.booking_id = b.booking_id
ORDER BY a.apartment_id ASC ;


-- 02. First 10 Apartments Booked At --

SELECT a.name AS name, a.country AS country, booked_at::DATE AS booked_at
FROM apartments a
    LEFT JOIN bookings b ON a.booking_id = b.booking_id
ORDER BY a.apartment_id
LIMIT 10 ;


-- 03. First 10 Customers with Bookings --

SELECT b.booking_id AS booking_id, starts_at::DATE AS starts_at, b.apartment_id AS apartment_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name
       FROM bookings b
    RIGHT JOIN customers c ON b.customer_id = c.customer_id
ORDER BY customer_name ASC
LIMIT 10 ;


-- 04. Booking Information --

SELECT b.booking_id AS booking_id, a.name AS apartment_owner, a.apartment_id AS apartment_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name
       FROM bookings b
    FULL OUTER JOIN apartments a ON a.booking_id = b.booking_id
    FULL OUTER JOIN customers c ON c.customer_id = b.customer_id
ORDER BY booking_id, apartment_owner, customer_name ASC ;


-- 05. Multiplication of Information --

SELECT b.booking_id AS booking_id, c.first_name AS customer_name FROM bookings b
    CROSS JOIN customers c
ORDER BY customer_name ASC ;


-- 06. Unassigned Apartments --

SELECT b.booking_id AS booking_id, b.apartment_id AS apartment_id,
c.companion_full_name AS companion_full_name
FROM bookings b
    INNER JOIN customers c ON c.customer_id = b.customer_id
WHERE b.apartment_id IS NULL ;


-- 07. Bookings Made by Lead --

SELECT b.apartment_id AS apartment_id, b.booked_for AS booked_for, c.first_name AS first_name,
c.country AS country
FROM bookings b
    INNER JOIN customers c ON c.customer_id = b.customer_id
WHERE c.job_type LIKE '%Lead%' ;


-- 08. Hahn`s Bookings --

SELECT COUNT(b.booking_id) FROM bookings b
    INNER JOIN customers c ON c.customer_id = b.customer_id
WHERE c.last_name = 'Hahn';


-- 09. Total Sum of Nights --

SELECT a.name AS name, SUM(b.booked_for) AS nights
FROM apartments a
    INNER JOIN bookings b ON a.apartment_id = b.apartment_id
GROUP BY name
ORDER BY name ASC ;


-- 10. Popular Vacation Destination --

SELECT a.country AS country, COUNT(b.booking_id) AS booking_count
FROM apartments a
    INNER JOIN bookings b ON a.apartment_id = b.apartment_id
WHERE b.booked_at > '2021-05-18 07:52:09.904+03'
AND b.booked_at < '2021-09-17 19:48:02.147+03'
GROUP BY country
ORDER BY booking_count DESC ;


-- 11. Bulgaria's Peaks Higher than 2835 Meters --

SELECT mc.country_code, m.mountain_range, p.peak_name, p.elevation FROM mountains m
    INNER JOIN peaks p ON m.id = p.mountain_id
    INNER JOIN mountains_countries mc ON m.id = mc.mountain_id
WHERE p.elevation > 2835
and mc.country_code = 'BG'
ORDER BY p.elevation DESC


-- 12. Count Mountain Ranges --

SELECT mc.country_code, COUNT(m.id) AS mountain_range_count FROM mountains m
    INNER JOIN mountains_countries mc ON m.id = mc.mountain_id
WHERE mc.country_code IN ('BG', 'RU', 'US')
GROUP BY mc.country_code
ORDER BY mountain_range_count DESC ;


-- 13. Rivers in Africa --

SELECT c.country_name, r.river_name  FROM countries c
    FULL OUTER JOIN countries_rivers cr ON c.country_code = cr.country_code
    FULL OUTER JOIN rivers r ON r.id = cr.river_id
WHERE c.continent_code = 'AF'
ORDER BY country_name ASC
LIMIT 5 ;


-- 14. Minimum Average Area Across Continents --

SELECT AVG(area_in_sq_km) AS min_average_area FROM countries
GROUP BY continent_code
ORDER BY min_average_area ASC
LIMIT 1 ;


-- 15. Countries Without Any Mountains --

SELECT COUNT(c.id) FROM countries c
    FULL OUTER JOIN mountains_countries mc ON c.country_code = mc.country_code
WHERE mc.mountain_id IS NULL ;


-- 16. Monasteries by Country --

CREATE TABLE monasteries (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    monastery_name VARCHAR(255),
    country_code CHAR(2)
) ;

INSERT INTO monasteries (monastery_name, country_code)
VALUES ('Rila Monastery "St. Ivan of Rila"', 'BG'),
  ('Bachkovo Monastery "Virgin Mary"', 'BG'),
  ('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
  ('Kopan Monastery', 'NP'),
  ('Thrangu Tashi Yangtse Monastery', 'NP'),
  ('Shechen Tennyi Dargyeling Monastery', 'NP'),
  ('Benchen Monastery', 'NP'),
  ('Southern Shaolin Monastery', 'CN'),
  ('Dabei Monastery', 'CN'),
  ('Wa Sau Toi', 'CN'),
  ('Lhunshigyia Monastery', 'CN'),
  ('Rakya Monastery', 'CN'),
  ('Monasteries of Meteora', 'GR'),
  ('The Holy Monastery of Stavronikita', 'GR'),
  ('Taung Kalat Monastery', 'MM'),
  ('Pa-Auk Forest Monastery', 'MM'),
  ('Taktsang Palphug Monastery', 'BT'),
  ('Sümela Monastery', 'TR');

ALTER TABLE countries
ADD COLUMN three_rivers BOOLEAN DEFAULT FALSE ;

SELECT country_code, COUNT(river_id) FROM countries_rivers
GROUP BY country_code
HAVING COUNT(river_id) >= 3 ;

/*
UPDATE
	countries
SET three_rivers = (
	SELECT
		COUNT(*) >= 3
	FROM
		countries_rivers AS cr
	WHERE
		cr.country_code = countries.country_code
); */

UPDATE countries
SET three_rivers = TRUE
WHERE country_code IN ('RU', 'US', 'CN', 'BR', 'CA');

SELECT * FROM countries
WHERE three_rivers IS TRUE ;

SELECT m.monastery_name AS monastery, c.country_name AS country FROM monasteries m
    JOIN countries c ON m.country_code = c.country_code
WHERE c.three_rivers IS FALSE
ORDER BY monastery ASC ;


-- 17. Monasteries by Continents and Countries --

UPDATE countries
SET country_name = 'Burma'
WHERE country_name = 'Myanmar' ;

INSERT INTO monasteries (monastery_name, country_code)
VALUES ('Hanga Abbey' , (SELECT country_code FROM countries WHERE country_name = 'Tanzania')),
       ('Myin-Tin-Daik', (SELECT country_code FROM countries WHERE country_name = 'Myanmar')) ;


SELECT TRIM(cnt.continent_name) AS continent_name, c.country_name, COUNT(m.country_code) AS monasteries_count FROM countries c
    JOIN continents cnt ON cnt.continent_code = c.continent_code
    LEFT JOIN monasteries m ON c.country_code = m.country_code
WHERE c.three_rivers IS FALSE
GROUP BY cnt.continent_name, c.country_name
ORDER BY monasteries_count DESC, country_name ASC ;


-- 18. Retrieving Information about Indexes --

SELECT tablename, indexname, indexdef FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename ASC, indexname ASC ;


-- 19. Continents and Currencies --

CREATE VIEW continent_currency_usage AS
SELECT ra.continent_code, ra.currency_code, ra.currency_usage
FROM (
	SELECT ct.continent_code, ct.currency_code, ct.currency_usage,
		DENSE_RANK() OVER(PARTITION BY ct.continent_code ORDER BY ct.currency_usage DESC) AS ranked_by_usage
	FROM (
		SELECT continent_code, currency_code, COUNT(currency_code) AS currency_usage
		FROM countries
		GROUP BY continent_code, currency_code
		HAVING COUNT(currency_code) > 1
	) AS ct
) AS ra
WHERE ra.ranked_by_usage = 1
ORDER BY ra.currency_usage DESC;


-- 20. The Highest Peak in Each Country --

WITH "row_number" AS (
	SELECT
		c.country_name,
		COALESCE(p.peak_name, '(no highest peak)') AS highest_peak_name,
		COALESCE(p.elevation, 0) AS highest_peak_elevation,
		COALESCE(m.mountain_range, '(no mountain)') AS mountain,
		ROW_NUMBER() OVER(PARTITION BY c.country_name ORDER BY p.elevation DESC) AS row_num
	FROM countries AS c
	LEFT JOIN mountains_countries AS mc USING (country_code)
	LEFT JOIN peaks AS p USING (mountain_id)
	LEFT JOIN mountains AS m ON m.id = p.mountain_id
)
SELECT country_name, highest_peak_name, highest_peak_elevation, mountain
FROM "row_number"
WHERE row_num = 1
ORDER BY country_name ASC, highest_peak_elevation DESC;
