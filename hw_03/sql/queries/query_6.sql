select customer_id, order_id
from (
  select
    customer.customer_id,
    orders.order_id,
    row_number() over (
      partition by customer.customer_id
      order by orders.order_date
    ) as rn
  from customer
    join orders on customer.customer_id = orders.customer_id
)
where rn = 2
order by customer_id;
