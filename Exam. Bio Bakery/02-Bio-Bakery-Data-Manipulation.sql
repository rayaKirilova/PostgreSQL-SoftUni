-- 01. INSERT --

CREATE TABLE gift_recipients (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50),
    country_id INT,
    gift_sent BOOLEAN DEFAULT FALSE
) ;

INSERT INTO gift_recipients (name, country_id)
SELECT
    concat(first_name, ' ', last_name),
    country_id
FROM customers ;

SELECT * FROM gift_recipients ;

UPDATE gift_recipients
SET gift_sent = TRUE
WHERE country_id IN (7, 8, 14, 17, 26) ;

-- other solution --
/*
 INSERT INTO gift_recipients (
	"name", country_id, gift_sent
)
SELECT
  CONCAT(first_name, ' ', last_name) AS "name",
  country_id AS "country_id",
  CASE
    WHEN country_id IN (7, 8, 14, 17, 26) THEN TRUE
    ELSE FALSE
  END AS gift_sent
FROM customers;
 */


-- 02. UPDATE --

UPDATE products
SET price = price * 1.1
WHERE id IN (SELECT product_id FROM feedbacks
             WHERE rate > 8 ) ;


-- 03. DELETE --

-- Delete distributor and related records
DELETE FROM distributors
WHERE "name" LIKE 'L%';


-- Delete related records from the ingredients table
DELETE FROM ingredients
WHERE distributor_id IN (
    SELECT id
    FROM distributors
    WHERE "name" LIKE 'L%'
);


-- Delete related records from the products_ingredients table
DELETE FROM products_ingredients
WHERE ingredient_id IN (
    SELECT id
    FROM distributors
    WHERE "name" LIKE 'L%'
);

