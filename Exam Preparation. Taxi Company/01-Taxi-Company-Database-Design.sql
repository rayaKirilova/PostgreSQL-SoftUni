-- Database Design --

--CREATE DATABASE taxi_db ;

CREATE TABLE addresses (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(10) NOT NULL
);

CREATE TABLE clients (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL,
    rating NUMERIC(3, 2) DEFAULT 5.5,
    CONSTRAINT drivers_age_check CHECK (age > 0)
);

CREATE TABLE cars (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    make VARCHAR(20) NOT NULL,
    model VARCHAR(20),
    year INT NOT NULL DEFAULT 1,
    mileage INT DEFAULT 1,
    condition CHAR(1) NOT NULL,

    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT cars_year_check CHECK (year > 0),
    CONSTRAINT cars_mileage_check CHECK (mileage > 0)
);

CREATE TABLE courses (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    from_address_id INT NOT NULL,
    FOREIGN KEY (from_address_id ) REFERENCES addresses(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    start TIMESTAMP NOT NULL,
    bill NUMERIC(10, 2) DEFAULT 10,

    car_id INT NOT NULL,
    FOREIGN KEY (car_id) REFERENCES cars(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    client_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT bill_check CHECK (bill > 0)
);

CREATE TABLE cars_drivers(
    car_id INT NOT NULL,
    FOREIGN KEY (car_id) REFERENCES cars(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    driver_id INT NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES drivers(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
