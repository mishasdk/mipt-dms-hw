WITH it_customers AS (
    SELECT customer.customer_id AS customer_id, customer.first_name AS first_name, customer.last_name AS last_name
    FROM customer
    WHERE customer.job_industry_category = 'IT'
),
top_road_products AS (
    SELECT product.product_id AS product_id
    FROM product
    WHERE product.product_line = 'Road'
    ORDER BY product.list_price DESC
    LIMIT 5
)
SELECT it_customers.customer_id, it_customers.first_name, it_customers.last_name
FROM it_customers
JOIN orders ON it_customers.customer_id = orders.customer_id
JOIN order_items ON orders.order_id = order_items.order_id
WHERE order_items.product_id IN (SELECT product_id FROM top_road_products)
GROUP BY it_customers.customer_id, it_customers.first_name, it_customers.last_name
HAVING COUNT(DISTINCT order_items.product_id) = 2;