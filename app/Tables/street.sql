create table app.street
(
	street_id serial,
	street_name varchar(150) not null,
	street_name_ascii varchar(150) not null,
	zipcode char(8),
	longitude double precision null,
	latitude  double precision null,
	neighborhood_id integer,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_street primary key (street_id),
	constraint fk_street_neighborhood foreign key (neighborhood_id) references app.neighborhood(neighborhood_id),
	constraint fk_street_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_street_modified_by foreign key (modified_by) references app.user_login(user_id)
);