(
SELECT job_title
FROM customer
WHERE job_industry_category = 'IT'
    AND job_title LIKE 'Senior%'
    AND EXTRACT(YEAR FROM AGE("DOB")) > 35
)
UNION ALL
(
SELECT job_title
FROM customer
WHERE job_industry_category = 'Financial Services'
    AND job_title LIKE 'Lead%'
    AND EXTRACT(YEAR FROM AGE("DOB")) > 35
);