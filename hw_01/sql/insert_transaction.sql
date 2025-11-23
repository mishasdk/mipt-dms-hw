INSERT INTO transactions (
    transaction_id, 
    product_id, 
    product_brand, 
    customer_id, 
    transaction_date, 
    online_order, 
    order_status
) VALUES (
    :transaction_id, 
    :product_id, 
    :product_brand, 
    :customer_id, 
    :transaction_date, 
    :online_order, 
    :order_status
)
ON CONFLICT (transaction_id) DO NOTHING;;