create table app.quote_product
(
	quote_id   bigint,
	product_id integer,
	is_active boolean default true,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_quote_product primary key (quote_id, product_id),
	constraint fk_quote_product_quote foreign key (quote_id) references app.quote(quote_id),
	constraint fk_quote_product_product foreign key (product_id) references app.product(product_id)
);