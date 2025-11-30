select customer.job_industry_category, count(customer.customer_id) as customers
from customer
group by customer.job_industry_category
order by customers desc;
