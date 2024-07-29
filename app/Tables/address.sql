create table app.address
(
	address_id serial,
	street_id integer,
	complement varchar(200),
	complement_ascii varchar(200),
	longitude double precision null,
	latitude  double precision null,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_address primary key (address_id),
	constraint fk_address_street foreign key (street_id) references app.street(street_id),
	constraint fk_address_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_address_modified_by foreign key (modified_by) references app.user_login(user_id)
);