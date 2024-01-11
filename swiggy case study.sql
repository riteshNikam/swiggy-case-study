-- 1. Find customers who have never ordered

SELECT user_id, name FROM users
WHERE user_id NOT IN 
(
	SELECT DISTINCT user_id FROM orders
);

-- 2. Average Price/dish

SELECT f_name, avg_price FROM food JOIN 
(
	SELECT f_id, ROUND(AVG(price)) AS avg_price FROM menu
	GROUP BY f_id
) AS temp ON food.f_id = temp.f_id;

-- 3. Find the top restaurant in terms of the number of orders for a given month

SELECT t2.month, r.r_name, t2.orders FROM 
(
	SELECT *, RANK() OVER (PARTITION BY month ORDER BY orders DESC) AS ranked FROM
	(
		SELECT
			MONTHNAME(date) AS month, 
			r_id,
			COUNT(order_id) AS orders
		FROM orders
		GROUP BY month, r_id 
		ORDER BY month, r_id
	) AS t
) AS t2 JOIN restaurants AS r ON t2.r_id = r.r_id
WHERE t2.ranked = 1;

-- 4. restaurants with monthly sales greater than 500 for month of JUNE

SELECT * FROM 
(
	SELECT r.r_name, SUM(amount) sales FROM orders AS o JOIN restaurants AS r
	ON o.r_id = r.r_id
	WHERE MONTHNAME(date) like 'June'
	GROUP BY o.r_id
) AS temp WHERE sales > 500;

-- 5. Show all orders with order details for a particular customer 
-- (user_id = 3, VARTIKA)
-- in a particular month (june)

SELECT MONTHNAME(date) AS month, name, order_id, r_name, p_name, f_name, amount FROM ( 
SELECT temp4.*, f.f_name FROM (
SELECT temp3.*, dp.p_name FROM (
SELECT temp2.*, r.r_name FROM (
SELECT temp.*, u.name FROM (
SELECT o.*, od.f_id FROM orders AS o JOIN order_details AS od
ON o.order_id = od.order_id 
WHERE MONTHNAME(date) = 'June' and user_id = 3) AS temp JOIN users AS u
ON temp.user_id = u.user_id) AS temp2 JOIN restaurants AS r
ON temp2.r_id = r.r_id) AS temp3 JOIN delivery_partner AS dp
ON temp3.p_id = dp.p_id) AS temp4 JOIN food AS f 
ON temp4.f_id = f.f_id) AS temp5;

-- 6. Find restaurants with max repeated customers 

SELECT r.r_name, u.name, orders FROM (
SELECT r_id, user_id, COUNT(order_id) AS orders, 
RANK() over (ORDER BY COUNT(order_id) DESC) AS ranked FROM orders
GROUP BY r_id, user_id) AS temp JOIN users AS u ON temp.user_id = u.user_id 
JOIN restaurants AS r ON temp.r_id = r.r_id
WHERE ranked = 1;

-- 7. Month over month revenue growth of swiggy

SELECT 
	MONTHNAME(date) AS month,
	SUM(amount) AS revenue,
	ROUND((SUM(amount) - LAG(SUM(amount), 1) OVER ()) / SUM(amount) * 100, 2) AS delta_precetage
FROM orders
GROUP BY MONTHNAME(date); 
