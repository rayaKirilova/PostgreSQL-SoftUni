-- 01. Volunteers --

SELECT name, phone_number, address, animal_id, department_id FROM volunteers
ORDER BY name ASC, animal_id ASC, department_id ASC ;


-- 02. Animals Data --

SELECT a.name, at.animal_type, TO_CHAR(a.birthdate, 'DD.MM.YYYY') AS birthdate FROM animals a
    INNER JOIN animal_types at ON a.animal_type_id = at.id
ORDER BY a.name ASC ;


-- 03. Owners and Their Animals --

SELECT o.name AS owner, COUNT(*) AS count_of_animlas FROM animals a
    INNER JOIN owners o ON a.owner_id = o.id
GROUP BY o.name
ORDER BY count_of_animlas DESC, o.name ASC
LIMIT 5 ;


-- 04. Owners, Animals and Cages --

SELECT CONCAT(o.name, ' - ', a.name) AS "owners - animals",
       o.phone_number, ac.cage_id
FROM animals a
    INNER JOIN owners o ON a.owner_id = o.id
    INNER JOIN animals_cages ac ON a.id = ac.animal_id
    INNER JOIN animal_types at ON a.animal_type_id = at.id
WHERE at.id = 1
ORDER BY o.name ASC, a.name DESC ;


-- 05. Volunteers in Sofia --

SELECT v.name AS volunteers, v.phone_number,
       TRIM(BOTH ' ' FROM REGEXP_REPLACE(v.address, 'Sofia[ ,]*', '', 'g')) AS address
FROM volunteers v
    INNER JOIN volunteers_departments vd ON v.department_id = vd.id
WHERE vd.id = 2
AND v.address LIKE '%Sofia%'
ORDER BY v.name ASC ;


-- 06. Animals for Adoption --

SELECT a.name AS animal,
       EXTRACT(YEAR FROM a.birthdate) AS birth_year,
       at.animal_type FROM animals a
    INNER JOIN animal_types at ON a.animal_type_id = at.id
WHERE a.owner_id IS NULL
AND at.id <> 3
AND EXTRACT(YEAR FROM AGE('01/01/2022', a.birthdate)) < 5
ORDER BY a.name ASC ;



