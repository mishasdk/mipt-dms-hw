select 
  to_char(orders.order_date, 'YYYY-MM') AS year_month,
  customer.job_industry_category, 
  sum(product.list_price * order_items.quantity)
from customer
  join orders on customer.customer_id = orders.customer_id
  join order_items on orders.order_id = order_items.order_id
  join product on order_items.product_id = product.product_id
where orders.order_status = 'Approved'
group by
  to_char(orders.order_date, 'YYYY-MM'),
  customer.job_industry_category
order by year_month;
