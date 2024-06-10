create table app.city
(
	city_id smallserial,
	city_name varchar(50) not null,
	city_name_ascii varchar(50) not null,
	longitude double precision null,
	latitude  double precision null,
	state_id smallint,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_city primary key (city_id),
	constraint fk_city_state foreign key (state_id) references app.state(state_id),
	constraint uk_city_name unique (city_name, state_id)
);