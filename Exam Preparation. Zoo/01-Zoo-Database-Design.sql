-- 1.1. Database Design --
CREATE DATABASE zoo_db ;

CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address VARCHAR(50)
);

CREATE TABLE animal_types (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    animal_type VARCHAR(30) NOT NULL
);

CREATE TABLE cages (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    animal_type_id INT NOT NULL,

    CONSTRAINT fk_animal_type
    FOREIGN KEY (animal_type_id) REFERENCES animal_types(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    birthdate DATE NOT NULL,

    owner_id INT,
    CONSTRAINT fk_owner
    FOREIGN KEY (owner_id) REFERENCES owners(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    animal_type_id INT NOT NULL,
    CONSTRAINT fk_animal_type
    FOREIGN KEY (animal_type_id) REFERENCES animal_types(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE volunteers_departments (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR(30) NOT NULL
) ;

CREATE TABLE volunteers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address VARCHAR(50),

    animal_id INT,
    CONSTRAINT fk_animal_volunteer
    FOREIGN KEY (animal_id) REFERENCES animals(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    department_id INT NOT NULL,
    CONSTRAINT fk_volunteer_department
    FOREIGN KEY (department_id) REFERENCES volunteers_departments(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ;

CREATE TABLE animals_cages (
    cage_id INT NOT NULL,
    CONSTRAINT fk_cage_animal
    FOREIGN KEY (cage_id) REFERENCES cages(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    animal_id INT NOT NULL,
    CONSTRAINT fk_animal_cage
    FOREIGN KEY (animal_id) REFERENCES animals(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ;

