-- Create DB --
-- CREATE DATABASE sm_profiles_db

-- Create Tables --

CREATE TABLE accounts (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL,
        CONSTRAINT check_gender CHECK(gender in ('M', 'F')),
    age INT NOT NULL,
    job_title VARCHAR(40) NOT NULL,
    ip VARCHAR(30) NOT NULL
);

CREATE TABLE addresses (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    street VARCHAR(30) NOT NULL,
    town VARCHAR(30) NOT NULL,
    country VARCHAR(30) NOT NULL,

    account_id INT NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE photos (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    description TEXT,
    capture_date TIMESTAMP NOT NULL,
    views INT DEFAULT 0 NOT NULL,
        CONSTRAINT check_views CHECK(views >= 0)
);

CREATE TABLE comments (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    content VARCHAR(255) NOT NULL,
    published_on TIMESTAMP NOT NULL,
    photo_id INT NOT NULL,
    FOREIGN KEY (photo_id) REFERENCES photos(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE accounts_photos (
    account_id INT NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    photo_id INT NOT NULL,
    FOREIGN KEY (photo_id) REFERENCES photos(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (account_id, photo_id)
);

CREATE TABLE likes (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    photo_id INT NOT NULL,
    FOREIGN KEY (photo_id) REFERENCES photos(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    account_id INT NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE


);