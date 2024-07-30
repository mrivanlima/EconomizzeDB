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
	constraint pk_product primary key (product_id),
	constraint uk_product_name_ascii unique (product_name_ascii),
	constraint fk_product_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_product_modified_by foreign key (modified_by) references app.user_login(user_id)
);