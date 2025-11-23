(
SELECT customer.customer_id, customer.first_name, customer.last_name, customer.job_industry_category
FROM customer
JOIN orders ON customer.customer_id = orders.customer_id
JOIN order_items ON orders.order_id = order_items.order_id
WHERE customer.job_industry_category = 'IT'
    AND orders.order_date BETWEEN '2017-01-01' AND '2017-03-01'
    AND orders.order_status = 'Approved'
GROUP BY customer.customer_id, customer.first_name, customer.last_name, customer.job_industry_category
HAVING COUNT(DISTINCT orders.order_id) >= 3
    AND SUM(order_items.quantity * order_items.item_list_price_at_sale) > 10000
)
UNION
(
SELECT customer.customer_id, customer.first_name, customer.last_name, customer.job_industry_category
FROM customer
JOIN orders ON customer.customer_id = orders.customer_id
JOIN order_items ON orders.order_id = order_items.order_id
WHERE customer.job_industry_category = 'Health'
    AND orders.order_date BETWEEN '2017-01-01' AND '2017-03-01'
    AND orders.order_status = 'Approved'
GROUP BY customer.customer_id, customer.first_name, customer.last_name, customer.job_industry_category
HAVING COUNT(DISTINCT orders.order_id) >= 3
    AND SUM(order_items.quantity * order_items.item_list_price_at_sale) > 10000
);