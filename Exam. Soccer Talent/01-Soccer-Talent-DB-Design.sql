-- 01. Create DB --

CREATE DATABASE soccer_talent_db ;

-- 02. Create Tables --

CREATE TABLE towns (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(45) NOT NULL
);

CREATE TABLE stadiums (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    capacity INT NOT NULL,
    CONSTRAINT capacity_check CHECK (capacity > 0),

    town_id INT NOT NULL,
    FOREIGN KEY (town_id) REFERENCES towns(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE teams (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    established DATE NOT NULL,
    fan_base INT DEFAULT 0 NOT NULL,
    CONSTRAINT fan_base_check CHECK (fan_base >= 0),

    stadium_id INT NOT NULL,
    FOREIGN KEY (stadium_id) REFERENCES stadiums(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE coaches (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary NUMERIC(10, 2) DEFAULT 0 NOT NULL,
    CONSTRAINT salary_check CHECK (salary >= 0),

    coach_level INT DEFAULT 0 NOT NULL,
    CONSTRAINT coach_level_check CHECK (coach_level >= 0)
);

CREATE TABLE skills_data (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dribbling INT DEFAULT 0,
    CONSTRAINT dribbling_check CHECK (dribbling >= 0),

    pace INT DEFAULT 0,
    CONSTRAINT pace_check CHECK (pace >= 0),

    passing INT DEFAULT 0,
    CONSTRAINT passing_check CHECK (passing >= 0),

    shooting INT DEFAULT 0,
    CONSTRAINT shooting_check CHECK (shooting >= 0),

    speed INT DEFAULT 0,
    CONSTRAINT speed_check CHECK (speed >= 0),

    strength INT DEFAULT 0,
    CONSTRAINT strength_check CHECK (strength >= 0)
);

CREATE TABLE players (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,

    age INT DEFAULT 0 NOT NULL,
    CONSTRAINT age_check CHECK (age >= 0),

    position CHAR(1) NOT NULL,

    salary NUMERIC(10, 2) DEFAULT 0 NOT NULL,
    CONSTRAINT salary_check CHECK (salary >= 0),

    hire_date TIMESTAMP,

    skills_data_id INT NOT NULL,
    FOREIGN KEY (skills_data_id) REFERENCES skills_data(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    team_id INT,
     FOREIGN KEY (team_id) REFERENCES teams(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE players_coaches (
    player_id INT,
    FOREIGN KEY (player_id) REFERENCES players(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

     coach_id INT,
     FOREIGN KEY (coach_id) REFERENCES coaches(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
