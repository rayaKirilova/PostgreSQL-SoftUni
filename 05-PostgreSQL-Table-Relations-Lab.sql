-- 0 --
CREATE DATABASE camp ;


-- 01. Mountains and Peaks --
CREATE TABLE mountains (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) ;

CREATE TABLE peaks (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    mountain_id INT,

    CONSTRAINT fk_peaks_mountains
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
) ;


-- 02. Trip Organization --
SELECT vh.driver_id, vh.vehicle_type, CONCAT(cmp.first_name, ' ', cmp.last_name) FROM campers cmp
    JOIN vehicles vh ON  cmp.id = vh.driver_id


-- 03. SoftUni Hiking --
SELECT rts.start_point, rts.end_point, rts.leader_id, CONCAT(cmp.first_name, ' ', cmp.last_name) FROM campers cmp
    JOIN routes rts ON  rts.leader_id = cmp.id


-- 04. Delete Mountains --
CREATE TABLE mountains (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) ;


CREATE TABLE peaks (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    mountain_id INT,

    CONSTRAINT fk_mountain_id
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
    ON DELETE CASCADE
) ;


-- 05. Project Management DB --
CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
) ;

CREATE TABLE projects (
    id SERIAL PRIMARY KEY
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    project_id INT REFERENCES projects
);

ALTER TABLE projects
ADD COLUMN client_id INT REFERENCES clients,
ADD COLUMN project_lead_id INT REFERENCES employees


