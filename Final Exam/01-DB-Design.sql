 -- CREATE DATABASE online_store_db ;

CREATE TABLE brands (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE classifications (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE customers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    address VARCHAR(150) NOT NULL,
    phone VARCHAR(30) UNIQUE NOT NULL,
    loyalty_card BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE items (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,

    quantity INT NOT NULL,
    CONSTRAINT items_quantity_check CHECK(quantity >= 0),

    price NUMERIC(12, 2) NOT NULL,
    CONSTRAINT items_price_check CHECK(price > 0.00),

    description TEXT,

    brand_id INT NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES brands(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    classification_id INT NOT NULL,
    FOREIGN KEY (classification_id ) REFERENCES classifications(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE orders (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE reviews (
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    item_id INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES items(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (customer_id, item_id),

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    rating NUMERIC(3, 1) NOT NULL DEFAULT 0.0,
    CONSTRAINT reviews_rating_check CHECK(rating <= 10.0)
);

CREATE TABLE orders_items (
    order_id INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    item_id INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES items(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (order_id, item_id),

    quantity INT NOT NULL,
    CONSTRAINT orders_items_quantity_check CHECK(quantity >= 0)
);


