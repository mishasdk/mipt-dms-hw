SELECT product.brand
FROM product
JOIN order_items ON product.product_id = order_items.product_id
JOIN orders ON order_items.order_id = orders.order_id
JOIN customer ON orders.customer_id = customer.customer_id
WHERE customer.job_industry_category = 'Financial Services'
    AND product.brand NOT IN (
        SELECT DISTINCT product.brand
        FROM product
        JOIN order_items ON product.product_id = order_items.product_id
        JOIN orders ON order_items.order_id = orders.order_id
        JOIN customer ON orders.customer_id = customer.customer_id
        WHERE customer.job_industry_category = 'IT'
    );
