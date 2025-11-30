with orders_with_previos as (
  select
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    customer.job_title,
    orders.order_date,
    orders.order_date - lag(orders.order_date) over (partition by customer.customer_id order by order_date) as previous_interval
  from customer
  join orders on customer.customer_id = orders.customer_id
)
select 
  customer_id,
  first_name,
  last_name,
  job_title,
  max(previous_interval) as max_interval
from orders_with_previos
where previous_interval is not Null
group by 
  customer_id, 
  first_name, 
  last_name, 
  job_title
order by max_interval desc;
