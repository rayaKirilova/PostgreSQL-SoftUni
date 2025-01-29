-- 01. Players --

SELECT concat(first_name, ' ', last_name) AS full_name, age, hire_date FROM players
WHERE first_name LIKE 'M%'
ORDER BY age DESC, full_name ASC ;


-- 02. Offensive Players without Team --

SELECT p.id, concat(first_name, ' ', last_name) AS full_name, p.age, p.position, p.salary,
       sd.pace, sd.shooting FROM players p
    JOIN skills_data sd ON p.skills_data_id = sd.id
WHERE p.position = 'A'
AND p.team_id IS NULL
AND (sd.pace + sd.shooting) > 130 ;


-- 03. Teams with Player Count and Fan Base --

SELECT t.id AS team_id, t.name AS team_name, count(p.id) AS player_count, t.fan_base FROM teams t
    FULL OUTER JOIN players p ON p.team_id = t.id
WHERE t.fan_base > 30000
GROUP BY t.id, t.name, t.fan_base
ORDER BY player_count DESC, t.fan_base DESC ;


-- 04. Coaches, Players Skills and Teams Overview --

SELECT concat(c.first_name, ' ', c.last_name) AS coach_full_name,
       concat(p.first_name, ' ', p.last_name) AS player_full_name,
       t.name AS team_name,
       sd.passing, sd.shooting, sd.speed
       FROM players p
    JOIN players_coaches pc ON p.id = pc.player_id
    JOIN coaches c ON pc.coach_id = c.id
    JOIN teams t ON t.id = p.team_id
    JOIN skills_data sd ON p.skills_data_id = sd.id
ORDER BY coach_full_name ASC, player_full_name DESC ;

