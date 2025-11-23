INSERT INTO products (
    product_id, 
    product_brand, 
    product_line, 
    product_class, 
    product_size, 
    list_price, 
    standard_cost
) VALUES (
    :product_id,
    :product_brand, 
    :product_line, 
    :product_class, 
    :product_size, 
    :list_price,
    :standard_cost
)
ON CONFLICT (product_id, product_brand) DO NOTHING;