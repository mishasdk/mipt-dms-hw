WITH state_to_avg_valuation AS (
    SELECT customer.state, AVG(customer.property_valuation) AS avg_valuation
    FROM customer
    GROUP BY customer.state
),
filtered_customers AS (
    SELECT customer.customer_id, customer.first_name, customer.last_name
    FROM customer
    JOIN state_to_avg_valuation ON customer.state = state_to_avg_valuation.state
    WHERE customer.deceased_indicator = 'N'
        AND customer.property_valuation > state_to_avg_valuation.avg_valuation
)
SELECT filtered_customers.customer_id, filtered_customers.first_name, filtered_customers.last_name, COUNT(orders.order_id) as orders_number
FROM filtered_customers
JOIN orders ON filtered_customers.customer_id = orders.customer_id
JOIN order_items ON orders.order_id = order_items.order_id
JOIN product ON order_items.product_id = product.product_id
WHERE orders.online_order = true
    AND product.brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
GROUP BY filtered_customers.customer_id, filtered_customers.first_name, filtered_customers.last_name
ORDER BY orders_number DESC
LIMIT 10;
