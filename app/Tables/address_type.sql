
--What type of address? home, work, something else.
create table app.address_type
(
	address_type_id smallserial,
	address_type_name varchar(20),
	address_type_name_ascii varchar(20),
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_address_type primary key (address_type_id),
	constraint uk_address_type_name_ascii unique (address_type_name_ascii),
	constraint fk_address_type_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_address_type_modified_by foreign key (modified_by) references app.user_login(user_id)
);
