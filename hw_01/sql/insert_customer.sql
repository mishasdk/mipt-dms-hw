INSERT INTO customers (
  customer_id,
  postcode_id,
  first_name,
  last_name,
  gender,
  "DOB",
  job_title,
  job_industry_category,
  wealth_segment,
  deceased_indicator,
  owns_car,
  street_number,
  street_name,
  street_type,
  property_valuation
) VALUES (
  :customer_id,
  :postcode_id,
  :first_name,
  :last_name,
  :gender,
  :DOB,
  :job_title,
  :job_industry_category,
  :wealth_segment,
  :deceased_indicator,
  :owns_car,
  :street_number,
  :street_name,
  :street_type,
  :property_valuation
)
ON CONFLICT (customer_id) DO NOTHING;