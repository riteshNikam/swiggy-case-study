CREATE DATABASE swiggy;

USE swiggy;

CREATE TABLE users (
	user_id INT PRIMARY KEY,
    name VARCHAR(25),
    email VARCHAR(25),
    password VARCHAR(10)
);

SELECT * FROM users;

CREATE TABLE food (
	f_id INT PRIMARY KEY,
    f_name VARCHAR(25),
    type VARCHAR(25)
);

SELECT * FROM food;

CREATE TABLE restaurants (
	r_id INT PRIMARY KEY,
    r_name VARCHAR(25),
    cusine VARCHAR(25)
);

SELECT * FROM restaurants;

CREATE TABLE delivery_partner (
	p_id INT PRIMARY KEY,
    p_name VARCHAR(25)
);

SELECT * FROM delivery_partner;

CREATE TABLE orders (
	order_id INT PRIMARY KEY,
    user_id INT,
    r_id INT,
    amount INT,
    date DATE,
    p_id INT,
    delivery_time INT,
    delivery_rating INT,
    restaurant_rating INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (r_id) REFERENCES restaurants(r_id),
    FOREIGN KEY (p_id) REFERENCES delivery_partner(p_id)
);

SELECT * FROM orders;

CREATE TABLE order_details (
	id INT PRIMARY KEY,
    order_id INT,
    f_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (f_id) REFERENCES food(f_id)
);

SELECT * FROM order_details;

CREATE TABLE menu (
	menu_id INT PRIMARY KEY,
    r_id INT,
    f_id INT,
    price INT,
    FOREIGN KEY (r_id) REFERENCES restaurants(r_id),
    FOREIGN KEY (f_id) REFERENCES food(f_id)
);

SELECT * FROM menu;