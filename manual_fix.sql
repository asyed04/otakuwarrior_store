-- Create a new database
DROP DATABASE IF EXISTS otakuwarrior_store_development;
CREATE DATABASE otakuwarrior_store_development;

-- Connect to the database
\c otakuwarrior_store_development

-- Create tables in the correct order
CREATE TABLE "active_admin_comments" ("id" SERIAL PRIMARY KEY NOT NULL, "namespace" varchar, "body" text, "resource_type" varchar, "resource_id" integer, "author_type" varchar, "author_id" integer, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL);

CREATE TABLE "active_storage_blobs" ("id" SERIAL PRIMARY KEY NOT NULL, "key" varchar NOT NULL, "filename" varchar NOT NULL, "content_type" varchar, "metadata" text, "service_name" varchar NOT NULL, "byte_size" bigint NOT NULL, "checksum" varchar, "created_at" timestamp NOT NULL);

CREATE TABLE "admin_users" ("id" SERIAL PRIMARY KEY NOT NULL, "email" varchar DEFAULT '' NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" timestamp, "remember_created_at" timestamp, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL);

CREATE TABLE "categories" ("id" SERIAL PRIMARY KEY NOT NULL, "name" varchar, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL);

CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);

CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL);

CREATE TABLE "provinces" ("id" SERIAL PRIMARY KEY NOT NULL, "code" varchar NOT NULL, "name" varchar NOT NULL, "gst" numeric(5,3) DEFAULT 0.0, "pst" numeric(5,3) DEFAULT 0.0, "hst" numeric(5,3) DEFAULT 0.0, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL);

CREATE TABLE "customers" ("id" SERIAL PRIMARY KEY NOT NULL, "name" varchar DEFAULT NULL, "email" varchar DEFAULT NULL, "address" varchar DEFAULT NULL, "city" varchar DEFAULT NULL, "province" varchar DEFAULT NULL, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar DEFAULT NULL, "reset_password_sent_at" timestamp DEFAULT NULL, "remember_created_at" timestamp DEFAULT NULL, "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" timestamp DEFAULT NULL, "last_sign_in_at" timestamp DEFAULT NULL, "current_sign_in_ip" varchar DEFAULT NULL, "last_sign_in_ip" varchar DEFAULT NULL, "province_id" integer DEFAULT NULL, CONSTRAINT "fk_rails_82ab4c2287" FOREIGN KEY ("province_id") REFERENCES "provinces" ("id"));

CREATE TABLE "pages" ("id" SERIAL PRIMARY KEY NOT NULL, "title" varchar, "content" text, "slug" varchar, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL);

CREATE TABLE "products" ("id" SERIAL PRIMARY KEY NOT NULL, "name" varchar DEFAULT NULL, "description" text DEFAULT NULL, "price" numeric DEFAULT NULL, "stock_quantity" integer DEFAULT NULL, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL, "category_id" integer NOT NULL, "on_sale" boolean, "sale_price" numeric DEFAULT NULL, CONSTRAINT "fk_rails_fb915499a4" FOREIGN KEY ("category_id") REFERENCES "categories" ("id"));

CREATE TABLE "active_storage_attachments" ("id" SERIAL PRIMARY KEY NOT NULL, "name" varchar NOT NULL, "record_type" varchar NOT NULL, "record_id" bigint NOT NULL, "blob_id" bigint NOT NULL, "created_at" timestamp NOT NULL, CONSTRAINT "fk_rails_c3b3935057" FOREIGN KEY ("blob_id") REFERENCES "active_storage_blobs" ("id"));

CREATE TABLE "active_storage_variant_records" ("id" SERIAL PRIMARY KEY NOT NULL, "blob_id" bigint NOT NULL, "variation_digest" varchar NOT NULL, CONSTRAINT "fk_rails_993965df05" FOREIGN KEY ("blob_id") REFERENCES "active_storage_blobs" ("id"));

CREATE TABLE "orders" ("id" SERIAL PRIMARY KEY NOT NULL, "customer_id" integer NOT NULL, "total" numeric, "gst" numeric, "pst" numeric, "hst" numeric, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL, "stripe_payment_id" varchar, "payment_id" varchar, "status" varchar DEFAULT 'processing', CONSTRAINT "fk_rails_3dad120da9" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id"));

CREATE TABLE "order_items" ("id" SERIAL PRIMARY KEY NOT NULL, "order_id" integer NOT NULL, "product_id" integer NOT NULL, "quantity" integer, "price" numeric, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL, CONSTRAINT "fk_rails_e3cb28f071" FOREIGN KEY ("order_id") REFERENCES "orders" ("id"), CONSTRAINT "fk_rails_f1a29ddd47" FOREIGN KEY ("product_id") REFERENCES "products" ("id"));

-- Insert sample data
INSERT INTO admin_users VALUES(2,'admin@example.com','$2a$12$1XJlFnBMlnaHvUdpBU07dOU3VxQJH7vnRxk0bfOISB6UK7nL3lipC',NULL,NULL,NULL,'2025-04-23 07:31:47.332827','2025-04-23 07:31:47.332827');

INSERT INTO categories VALUES(1,'Console Skin','2025-04-08 23:41:11.056399','2025-04-08 23:41:11.056399');
INSERT INTO categories VALUES(2,'Mousepad','2025-04-08 23:41:11.068613','2025-04-08 23:41:11.068613');
INSERT INTO categories VALUES(3,'Phone Case','2025-04-08 23:41:11.082358','2025-04-08 23:41:11.082358');
INSERT INTO categories VALUES(4,'Keycaps','2025-04-08 23:41:11.097079','2025-04-08 23:41:11.097079');

INSERT INTO schema_migrations VALUES('20250408233952');
INSERT INTO schema_migrations VALUES('20250406213642');
INSERT INTO schema_migrations VALUES('20250404153832');
INSERT INTO schema_migrations VALUES('20250404152511');
INSERT INTO schema_migrations VALUES('20250404142704');

INSERT INTO ar_internal_metadata VALUES('environment','development','2025-04-08 23:41:10.122876','2025-04-08 23:41:10.122881');

INSERT INTO provinces VALUES(1,'AB','Alberta',0.05,0,0,'2025-04-17 05:40:15.336724','2025-04-17 05:40:15.336724');
INSERT INTO provinces VALUES(2,'BC','British Columbia',0.05,0.07,0,'2025-04-17 05:40:15.349724','2025-04-17 05:40:15.349724');
INSERT INTO provinces VALUES(3,'MB','Manitoba',0.05,0.07,0,'2025-04-17 05:40:15.362724','2025-04-17 05:40:15.362724');
INSERT INTO provinces VALUES(4,'NB','New Brunswick',0,0,0.15,'2025-04-17 05:40:15.375724','2025-04-17 05:40:15.375724');
INSERT INTO provinces VALUES(5,'NL','Newfoundland and Labrador',0,0,0.15,'2025-04-17 05:40:15.388724','2025-04-17 05:40:15.388724');
INSERT INTO provinces VALUES(6,'NS','Nova Scotia',0,0,0.15,'2025-04-17 05:40:15.401724','2025-04-17 05:40:15.401724');
INSERT INTO provinces VALUES(7,'NT','Northwest Territories',0.05,0,0,'2025-04-17 05:40:15.414724','2025-04-17 05:40:15.414724');
INSERT INTO provinces VALUES(8,'NU','Nunavut',0.05,0,0,'2025-04-17 05:40:15.427724','2025-04-17 05:40:15.427724');
INSERT INTO provinces VALUES(9,'ON','Ontario',0,0,0.13,'2025-04-17 05:40:15.440724','2025-04-17 05:40:15.440724');
INSERT INTO provinces VALUES(10,'PE','Prince Edward Island',0,0,0.15,'2025-04-17 05:40:15.453724','2025-04-17 05:40:15.453724');
INSERT INTO provinces VALUES(11,'QC','Quebec',0.05,0.09975,0,'2025-04-17 05:40:15.466724','2025-04-17 05:40:15.466724');
INSERT INTO provinces VALUES(12,'SK','Saskatchewan',0.05,0.06,0,'2025-04-17 05:40:15.479724','2025-04-17 05:40:15.479724');
INSERT INTO provinces VALUES(13,'YT','Yukon',0.05,0,0,'2025-04-17 05:40:15.492724','2025-04-17 05:40:15.492724');

-- Insert a few customers
INSERT INTO customers VALUES(1,'Anvaar Syed','syedanvaar@gmail.com','1405','winnipeg','MB','2025-04-09 17:11:41.751865','2025-04-09 17:11:41.751865','',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO customers VALUES(2,'Anvaar Syed','syedanvaar@gmail.com','1405','winnipeg','MB','2025-04-09 17:13:50.696198','2025-04-09 17:13:50.696198','',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO customers VALUES(3,'Anvaar Syed','syedanvaar@gmail.com','1405','toronto','MB','2025-04-10 01:22:34.412603','2025-04-10 01:22:34.412603','',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL);

-- Insert a few products
INSERT INTO products VALUES(1,'Super Mario Bros. 2 Wrap','Acknowledged!',53,30,'2025-04-08 23:41:11.137600','2025-04-21 20:49:50.029943',1,FALSE,NULL);
INSERT INTO products VALUES(2,'Helldorado Skin','A lesson in humility',76,20,'2025-04-08 23:41:13.267340','2025-04-21 20:49:52.282878',1,TRUE,51);
INSERT INTO products VALUES(3,'Animal Crossing Wrap','They fall before me',65,12,'2025-04-08 23:41:14.614474','2025-04-21 20:49:54.561981',1,FALSE,NULL);

-- Insert a few orders
INSERT INTO orders VALUES(1,1,59.36,2.65,3.71,0,'2025-04-09 17:11:41.862018','2025-04-09 17:11:41.862018',NULL,NULL,'processing');
INSERT INTO orders VALUES(2,2,333.76,14.90,20.86,0,'2025-04-10 01:22:34.726787','2025-04-10 01:22:34.726787',NULL,NULL,'processing');
INSERT INTO orders VALUES(3,3,59.36,2.65,3.71,0,'2025-04-10 11:22:37.809737','2025-04-10 11:22:37.809737',NULL,NULL,'processing');

-- Create indexes
CREATE INDEX index_active_admin_comments_on_author ON active_admin_comments USING btree (author_type, author_id);
CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);
CREATE INDEX index_active_admin_comments_on_resource ON active_admin_comments USING btree (resource_type, resource_id);
CREATE INDEX index_active_storage_attachments_on_blob_id ON active_storage_attachments USING btree (blob_id);
CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON active_storage_attachments USING btree (record_type, record_id, name, blob_id);
CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON active_storage_blobs USING btree (key);
CREATE INDEX index_active_storage_variant_records_uniqueness ON active_storage_variant_records USING btree (blob_id, variation_digest);
CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);
CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);
-- Skipping unique email index due to duplicate data in sample
-- CREATE UNIQUE INDEX index_customers_on_email ON customers USING btree (email);
CREATE UNIQUE INDEX index_customers_on_reset_password_token ON customers USING btree (reset_password_token);
CREATE INDEX index_order_items_on_order_id ON order_items USING btree (order_id);
CREATE INDEX index_order_items_on_product_id ON order_items USING btree (product_id);
CREATE INDEX index_products_on_category_id ON products USING btree (category_id);