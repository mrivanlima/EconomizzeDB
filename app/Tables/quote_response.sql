create table app.quote_response
(
	quote_id   bigint,
	drugstore_id integer,
	product_version_id integer,
	total_price numeric(10, 2),
	discount_percentage numeric(10, 2),
	total_final_price numeric(10, 2),
	is_active boolean default true,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_quote_response primary key (quote_id, drugstore_id, product_version_id),
	constraint fk_quote_response_quote foreign key (quote_id) references app.quote(quote_id),
	constraint fk_quote_response_drugstore foreign key (drugstore_id) references app.drugstore(drugstore_id),
	constraint fk_quote_response_product_version foreign key (product_version_id) references app.product_version(product_version_id)
);