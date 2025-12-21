-- Найти ТОП-5 клиентов (по общему доходу) в каждом сегменте благосостояния (wealth_segment). 
-- Вывести имя, фамилию, сегмент и общий доход. Если в сегменте менее 5 клиентов, вывести всех.

with customer_profit as (
  select 
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    customer.wealth_segment,
    sum(product.list_price * order_items.quantity) as profit,
    rank() over (
      partition by customer.wealth_segment
      order by sum(product.list_price * order_items.quantity) desc
    ) as profit_rank
  from customer
    join orders on customer.customer_id = orders.customer_id
    join order_items on orders.order_id = order_items.order_id
    join product on order_items.product_id = product.product_id
  group by 
    customer.customer_id, 
    customer.first_name,
    customer.last_name,
    customer.wealth_segment
)
select
  customer_id,
  first_name,
  last_name,
  wealth_segment,
  profit
from customer_profit
where profit_rank <= 5
order by wealth_segment asc, profit desc;
