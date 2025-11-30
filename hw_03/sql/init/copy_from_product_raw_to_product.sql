INSERT INTO product (
  product_id,
  brand,
  product_line,
  product_class,
  product_size,
  list_price,
  standard_cost
)
SELECT 
  product_id,
  brand,
  product_line,
  product_class,
  product_size,
  list_price,
  standard_cost
FROM (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY list_price DESC) AS rn
  FROM product_raw
) T
WHERE rn = 1;