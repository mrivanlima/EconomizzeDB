--This is for Generic, Similar or Original only
create table app.product_version
(
	product_version_id   smallserial,
	product_version_name   varchar(20),
	product_version_ascii   varchar(20),
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_product_version primary key (product_version_id),
	constraint uk_product_version_ascii unique (product_version_ascii),
	constraint fk_product_version_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_product_version_modified_by foreign key (modified_by) references app.user_login(user_id)
);

