-- EXPLAIN ANALYZE
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id;

-- EXPLAIN ANALYZE
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from film f,payment p
JOIN rental r ON p.payment_date = r.rental_date
JOIN customer c ON r.customer_id = c.customer_id
where date(p.payment_date) = '2005-07-30';

CREATE INDEX first_last_idx ON customer(last_name, first_name);
DROP INDEX first_last_idx ON customer;

CREATE INDEX amount_idx ON payment(amount);
DROP INDEX amount_idx ON payment;
