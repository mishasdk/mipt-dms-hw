select 
  brand, 
  coalesce(count(distinct orders.order_id), 0) as unique_orders_count
from product
  left join order_items on product.product_id = order_items.product_id
  left join orders on order_items.order_id = orders.order_id
  left join customer on orders.customer_id = customer.customer_id
    and orders.order_status = 'Approved' 
    and orders.online_order = True 
    and customer.job_industry_category = 'IT'
group by brand
order by unique_orders_count desc;