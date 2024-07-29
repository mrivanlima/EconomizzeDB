create table app.neighborhood
(
	neighborhood_id serial,
	neighborhood_name varchar(100) not null,
	neighborhood_name_ascii varchar(100) not null,
	longitude double precision null,
	latitude  double precision null,
	city_id smallint,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_neighborhood primary key (neighborhood_id),
	constraint fk_neighborhood_city foreign key (city_id) references app.city(city_id),
	constraint fk_neighborhood_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_neighborhood_modified_by foreign key (modified_by) references app.user_login(user_id)

);