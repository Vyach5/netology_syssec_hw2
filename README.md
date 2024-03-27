# Домашнее задание к занятию SDBSQL-20 
# «Индексы» - `Шорохов Вячеслав`

---

### Задание 1. 

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

#### Решение:

Берем значения из INFORMATION_SCHEMA.TABLES,  суммы всех индексов делим на сумму всех данных и умножаем на 100, для получения результата в процентах. 

Получившийся запрос:
```sql
SELECT SUM(index_length)/SUM(data_length)*100 AS homework
FROM INFORMATION_SCHEMA.TABLES;
```

`Результат запроса:`
![Скриншот 1](img/1.png)


---

### Задание 2 (исправленное). 

Выполните explain analyze следующего запроса:

```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```

- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

#### Решение:

Посмотрел вывод запроса, а также выполнил EXPLAIN ANALYZE, 
`EXPLAIN ANALYZE Первоначального запроса:`
![Скриншот 2](img/2.1.png)

Для оптимизации: 
1. Убрал лишнюю таблицу inventory так как ее наличие в запросе никак не меняет результат вывода запроса. 
2. Убрал таблицу film, так ак ее наличие в аргументах оконной функции никак не меняет результат запроса. 
3. Таблицы rental и customer добавил через JOIN, убрав их из аргументов WHERE. 
4. Условие WHERE поменял так, чтобы не равенство, а больше меньше и был убран оператор DATE для лучшей работы с индексом на payment_date. 
5. Вместо оконной функции был использован оператор GROUP BY получившийся запрос:
```sql
select DISTINCT concat(c.last_name, ' ', c.first_name), sum(p.amount)
FROM payment p
JOIN rental r ON p.payment_date = r.rental_date
JOIN customer c ON r.customer_id = c.customer_id
WHERE p.payment_date >= '2005-07-30' and p.payment_date < DATE_ADD('2005-07-30', INTERVAL 1 DAY)
GROUP BY c.customer_id
```

`EXPLAIN ANALYZE Получившегося запроса, было 4953, стало 6.68:`
![Скриншот 3](img/2.2.png)

Добавим индекс по дате и проверим время выполнения:
```sql
CREATE INDEX payment_date_idx ON payment(payment_date)
```

`EXPLAIN ANALYZE Получившегося запроса после добавления индекса, было 6.68, стало 3.1:`
![Скриншот 4](img/2.3.png)
`Строка в приближении, где видно, что добавленный индекс используется:`
![Скриншот 5](img/2.3.1.png)

Вывод: я оптимизировал запрос, существенно сократив время выполнения, а потом добавил индекс, который позволил еще больше сократить время выполнения.

---
