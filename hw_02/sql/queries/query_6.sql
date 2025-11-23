SELECT customer.customer_id, customer.first_name, customer.last_name
FROM customer
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM orders
        WHERE orders.customer_id = customer.customer_id
            AND orders.online_order = True
            AND orders.order_status = 'Approved'
            AND orders.order_date >= CURRENT_DATE - INTERVAL '1 year'
    )
    AND customer.owns_car = 'Yes'
    AND customer.wealth_segment != 'Mass Customer';