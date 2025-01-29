-- Create database --
CREATE DATABASE bio_bakery_db ;

-- Create tables --

CREATE TABLE countries (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE customers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1),
    CONSTRAINT customers_gender_check CHECK(gender IN ('M','F')),

    age INT NOT NULL,
    CONSTRAINT customers_age_check CHECK (age > 0),

    phone_number CHAR(10) NOT NULL,

    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE products (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    description VARCHAR(250),
    recipe TEXT,

    price NUMERIC(10, 2) NOT NULL,
    CONSTRAINT products_price_check CHECK (price > 0)
);

CREATE TABLE feedbacks (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    description VARCHAR(255),

    rate NUMERIC(4, 2),
    CONSTRAINT feedbacks_rate_check CHECK (rate between 0 and 10),

    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE distributors (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(25) UNIQUE NOT NULL,
    address VARCHAR(30) NOT NULL,
    summary VARCHAR(200) NOT NULL,

   country_id INT NOT NULL,
   FOREIGN KEY (country_id) REFERENCES countries(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE ingredients (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(200),

    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    distributor_id INT NOT NULL,
    FOREIGN KEY (distributor_id) REFERENCES distributors(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ;

CREATE TABLE products_ingredients (
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES products (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    ingredient_id INT,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ;
