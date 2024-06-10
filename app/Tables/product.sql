create table app.product
(
	product_id serial,
	product_name varchar(200),
	product_name_ascii varchar(200),
	product_concentration varchar(20),
	Product_quantity smallint,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_product primary key (product_id)
);