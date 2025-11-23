SELECT DISTINCT product.brand
FROM product
JOIN order_items ON product.product_id = order_items.product_id
WHERE product.standard_cost > 1500
GROUP BY product.product_id
HAVING SUM(order_items.quantity) >= 1000;