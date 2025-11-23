CREATE TABLE "customer" (
  "customer_id" integer PRIMARY KEY NOT NULL,
  "first_name" varchar NOT NULL,
  "last_name" varchar,
  "gender" varchar NOT NULL,
  "DOB" date,
  "job_title" varchar,
  "job_industry_category" varchar,
  "wealth_segment" varchar NOT NULL,
  "deceased_indicator" varchar NOT NULL,
  "owns_car" varchar NOT NULL,
  "address" varchar NOT NULL,
  "postcode" integer NOT NULL,
  "state" varchar NOT NULL,
  "country" varchar NOT NULL,
  "property_valuation" integer NOT NULL
);

CREATE TABLE "product" (
  "product_id" integer PRIMARY KEY NOT NULL,
  "brand" varchar NOT NULL,
  "product_line" varchar NOT NULL,
  "product_class" varchar NOT NULL,
  "product_size" varchar NOT NULL,
  "list_price" decimal(15, 2) NOT NULL,
  "standard_cost" decimal(15, 2) NOT NULL
);

CREATE TABLE "orders" (
  "order_id" integer PRIMARY KEY NOT NULL,
  "customer_id" integer NOT NULL,
  "order_date" date NOT NULL,
  "online_order" boolean,
  "order_status" varchar NOT NULL
);

ALTER TABLE "orders" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

CREATE TABLE "order_items" (
  "order_item_id" integer PRIMARY KEY NOT NULL,
  "order_id" integer NOT NULL,
  "product_id" integer NOT NULL,
  "quantity" real NOT NULL,
  "item_list_price_at_sale" decimal(15, 2) NOT NULL,
  "item_standard_cost_at_sale" decimal(15, 2)
);

ALTER TABLE "order_items" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("order_id");
ALTER TABLE "order_items" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("product_id");
