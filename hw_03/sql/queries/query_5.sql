select
  customer_id,
  first_name,
  last_name,
  sum_profit
from (
  select
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    coalesce(sum(order_items.quantity * product.list_price), 0) as sum_profit,
    dense_rank() over (order by sum(order_items.quantity * product.list_price) asc) as rank_min,
    dense_rank() over (order by sum(order_items.quantity * product.list_price) desc) as rank_max
  from customer
    left join orders on customer.customer_id = orders.customer_id
    left join order_items on orders.order_id = order_items.order_id
    left join product on order_items.product_id = product.product_id
  group by customer.customer_id, customer.first_name, customer.last_name
)
where rank_min <= 3 or rank_max <= 3
order by sum_profit desc;