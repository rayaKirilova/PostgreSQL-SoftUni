-- 01. INSERT --

INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT
    first_name,
    last_name,
    salary * 2 AS salary,
    LENGTH(first_name) AS coach_level
FROM
    players
WHERE
    hire_date < '2013-12-13 07:18:46';


-- 02. UPDATE --

UPDATE coaches
SET salary = salary * coach_level
WHERE substring(first_name FROM 1 FOR 1) = 'C'
AND id IN (SELECT DISTINCT coach_id
    FROM players_coaches
    WHERE coach_id IS NOT NULL) ;

select * from coaches
where substring(first_name from 1 for 1) = 'C' ;


-- 03. DELETE --
DELETE
FROM players_coaches
WHERE player_id IN (54, 17, 66, 71);

DELETE
FROM players
WHERE hire_date < '2013-12-13 07:18:46' ;


-- another solution --
DELETE FROM players_coaches
WHERE player_id IN (
    SELECT id
    FROM players
    WHERE hire_date < '2013-12-13 07:18:46'
);

DELETE FROM players
WHERE hire_date < '2013-12-13 07:18:46';