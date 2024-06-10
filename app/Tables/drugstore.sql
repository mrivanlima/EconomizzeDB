create table app.drugstore
(
	drugstore_id serial,
	drugstore_name varchar(200),
	dugrstore_name_ascii varchar(200),
	address_id integer,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_drugstore primary key (drugstore_id),
	constraint fk_drugstore_address foreign key (address_id) references app.address(address_id)
);