SELECT DISTINCT district 
FROM address
WHERE district LIKE 'K%a' AND district NOT LIKE '% %';

SELECT  payment_id, amount, payment_date, CAST(payment_date AS DATE)
FROM payment
WHERE amount > 10.00 AND CAST(payment_date AS DATE) >= '2005-06-15' AND CAST(payment_date AS DATE) <= '2005-06-18';

SELECT r.rental_date, f.title 
FROM rental r
JOIN inventory i  ON i.inventory_id = r.inventory_id
JOIN film f  ON i.film_id = f.film_id
ORDER BY rental_date DESC
LIMIT 5;

SELECT LOWER(REPLACE(first_name, 'LL', 'PP')), LOWER(last_name)
FROM customer
WHERE first_name LIKE 'Kelly' OR first_name LIKE 'Willie'  AND active > 0;
