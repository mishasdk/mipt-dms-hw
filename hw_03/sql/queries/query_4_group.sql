select
  customer.customer_id,
  coalesce(sum(order_items.quantity * product.list_price), 0) as sum_profit,
  max(order_items.quantity * product.list_price) as max_profit,
  min(order_items.quantity * product.list_price) as min_profit,
  coalesce(count(distinct orders.order_id), 0) as orders_count,
  avg(order_items.quantity * product.list_price) as average_profit
from customer
  left join orders on customer.customer_id = orders.customer_id
  left join order_items on orders.order_id = order_items.order_id
  left join product on order_items.product_id = product.product_id
group by customer.customer_id
order by sum_profit desc, orders_count desc