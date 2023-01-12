--- Task 1 Используем JOIN’ы

--- Название компании заказчика (company_name из табл. customers) и ФИО сотрудника,
--- работающего над заказом этой компании (см таблицу employees), когда и заказчик
--- и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания
--- United Package (company_name в табл shippers)
SELECT DISTINCT(c.company_name, CONCAT(first_name, ' ', last_name))  AS customer_and_employee
FROM orders
JOIN customers AS c USING(customer_id)
JOIN employees AS e USING(employee_id)
JOIN shippers AS s ON orders.ship_via=s.shipper_id
WHERE c.city = 'London' AND e.city = 'London'
AND s.company_name = 'United Package';

--- Наименование продукта, количество товара (product_name и units_in_stock в табл products),
--- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
--- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях
--- Dairy Products и Condiments. Отсортировать результат по возрастанию количества оставшегося товара.
SELECT products.product_name, products.units_in_stock, suppliers.contact_name, suppliers.phone
FROM products
JOIN suppliers USING(supplier_id)
JOIN categories USING(category_id)
WHERE discontinued = 0 AND units_in_stock < 25 AND category_name IN ('Dairy Products', 'Condiments')
ORDER BY units_in_stock;

--- Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT DISTINCT customers.company_name FROM customers
EXCEPT
SELECT DISTINCT customers.company_name FROM orders
JOIN customers USING(customer_id);

--- Task 2 Работа с подзапросами

--- уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных
--- единиц см в колонке quantity табл order_details)
SELECT p.product_name FROM products AS p
WHERE EXISTS (SELECT 1 FROM order_details AS od WHERE p.product_id=od.product_id
			 AND od.quantity = 10)
