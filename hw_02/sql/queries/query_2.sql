SELECT
    date::date,
    COUNT(orders.order_id) AS approved_online_orders,
    COUNT(DISTINCT orders.customer_id) AS unique_customers
FROM
    generate_series('2017-04-01'::date, '2017-04-09'::date, interval '1 day') AS date
LEFT JOIN orders
    ON orders.order_date = date::date
    AND orders.order_status = 'Approved'
    AND orders.online_order = True
GROUP BY date
ORDER BY date ASC;