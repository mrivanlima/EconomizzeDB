create table app.user_address
(
	user_id integer,
	street_id integer,
	address_id integer,
	address_type_id smallint,
	main_address	boolean default false,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user_address primary key (user_id, street_id, address_id, address_type_id),
	constraint fk_user_address_user foreign key (user_id) references app.user_login(user_id),
	constraint fk_user_address_street foreign key (street_id) references app.street(street_id),
	constraint fk_user_address_address foreign key (address_id) references app.address(address_id),
	constraint fk_user_address_address_type foreign key (address_type_id) references app.address_type(address_type_id),
	constraint fk_user_address_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_user_address_modified_by foreign key (modified_by) references app.user_login(user_id)
);