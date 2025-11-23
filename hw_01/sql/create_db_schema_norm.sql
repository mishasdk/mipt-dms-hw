CREATE TYPE "gender_enum" AS ENUM (
  'Male',
  'Female',
  'Unknown'
);

CREATE TABLE "customers" (
  "customer_id" integer PRIMARY KEY NOT NULL,
  "postcode_id" integer NOT NULL,
  "first_name" varchar NOT NULL,
  "last_name" varchar,
  "gender" gender_enum NOT NULL,
  "DOB" date,
  "job_title" varchar,
  "job_industry_category" varchar,
  "wealth_segment" varchar NOT NULL,
  "deceased_indicator" boolean NOT NULL,
  "owns_car" boolean NOT NULL,
  "street_number" varchar NOT NULL,
  "street_name" varchar NOT NULL,
  "street_type" varchar NOT NULL,
  "property_valuation" integer NOT NULL
);

CREATE TABLE "postcodes" (
  "postcode_id" integer PRIMARY KEY NOT NULL,
  "state" varchar NOT NULL,
  "country" varchar NOT NULL
);

CREATE TABLE "transactions" (
  "transaction_id" integer PRIMARY KEY,
  "product_id" integer,
  "product_brand" varchar,
  "customer_id" integer NOT NULL,
  "transaction_date" date NOT NULL,
  "online_order" boolean,
  "order_status" varchar NOT NULL
);

CREATE TABLE "products" (
  "product_id" integer NOT NULL,
  "product_brand" varchar NOT NULL,
  "product_line" varchar NOT NULL,
  "product_class" varchar NOT NULL,
  "product_size" varchar NOT NULL,
  "list_price" decimal(15, 2),
  "standard_cost" decimal(15, 2),
  PRIMARY KEY (product_id, product_brand)
);


ALTER TABLE "transactions" ADD FOREIGN KEY ("customer_id") REFERENCES "customers" ("customer_id");
ALTER TABLE "transactions" ADD FOREIGN KEY ("product_id", "product_brand") REFERENCES "products" ("product_id", "product_brand");

ALTER TABLE "customers" ADD FOREIGN KEY ("postcode_id") REFERENCES "postcodes" ("postcode_id");