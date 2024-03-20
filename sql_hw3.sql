SELECT s.store_id, COUNT(c.customer_id), CONCAT(s2.last_name, ' ', s2.first_name), c2.city
FROM store s
JOIN customer c ON c.store_id = s.store_id 
JOIN staff s2 ON s.manager_staff_id = s2.staff_id
JOIN address a ON a.address_id  = s.address_id 
JOIN city c2 ON c2.city_id = a.city_id
GROUP BY s.store_id, CONCAT(s2.last_name, ' ', s2.first_name), c2.city
HAVING COUNT(c.customer_id) > 300;

SELECT COUNT(film_id) 
FROM film
WHERE length > (SELECT AVG(length) FROM film);

SELECT SUM(amount) AS sum_amount, MONTH(payment_date) AS month_date, COUNT(rental_id) AS count_rental
FROM payment
GROUP BY MONTH(payment_date)
ORDER BY sum_amount DESC
LIMIT 1;

SELECT SUM(amount) AS sum_amount, MONTH(payment_date) AS month_date, COUNT(rental_id) AS count_rental
FROM payment
GROUP BY MONTH(payment_date)
HAVING sum_amount = 
(SELECT MAX(sum_amount) AS max_amount
FROM (SELECT SUM(amount) AS sum_amount, MONTH(payment_date) AS month_date
FROM payment
GROUP BY month_date) X);
