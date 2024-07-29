create table app.quote_product_response
(
	quote_id   bigint,
	product_id integer,
	drugstore_id integer,
	product_version_id integer,
	regular_price numeric(10, 2),
	discount_percentage numeric(10, 2),
	final_price numeric(10, 2),
	is_active boolean default true,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_quote_product_response primary key (quote_id, product_id, drugstore_id, product_version_id),
	constraint fk_quote_product_response_quote foreign key (quote_id) references app.quote(quote_id),
	constraint fk_quote_product_response_product foreign key (product_id) references app.product(product_id),
	constraint fk_quote_product_response_drugstore foreign key (drugstore_id) references app.drugstore(drugstore_id),
	constraint fk_quote_product_response_product_version foreign key (product_version_id) references app.product_version(product_version_id),
	constraint fk_quote_product_response_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_quote_product_response_modified_by foreign key (modified_by) references app.user_login(user_id)
);