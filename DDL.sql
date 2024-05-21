create schema if not exists app;

SELECT drop_all_foreign_keys();

drop table if exists app.state;
create table app.state
(
	state_id smallserial,
	state_name varchar(50) not null,
	state_name_ascii varchar(50) not null,
	longitude numeric (20, 10) null,
	latitude  numeric (20, 10) null,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_state primary key (state_id),
	constraint uk_state_name unique (state_name)
);


drop table if exists app.city;
create table app.city
(
	city_id smallserial,
	city_name varchar(50) not null,
	city_name_ascii varchar(50) not null,
	longitude numeric (20, 10) null,
	latitude  numeric (20, 10) null,
	state_id smallint,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_city primary key (city_id),
	constraint fk_city_state foreign key (state_id) references app.state(state_id),
	constraint uk_city_name unique (city_name, state_id)
);

drop table if exists app.neighborhood;
create table app.neighborhood
(
	neighborhood_id serial,
	neighborhood_name varchar(50) not null,
	neighborhood_name_ascii varchar(50) not null,
	longitude numeric (20, 10) null,
	latitude  numeric (20, 10) null,
	city_id smallint,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_neighborhood primary key (neighborhood_id),
	constraint fk_neighborhood_city foreign key (city_id) references app.city(city_id)
);

drop table if exists app.street;
create table app.street
(
	street_id serial,
	street_name varchar(50) not null,
	street_name_ascii varchar(50) not null,
	zipcode char(8),
	longitude numeric (20, 10) null,
	latitude  numeric (20, 10) null,
	neighborhood_id integer,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_street primary key (street_id),
	constraint fk_street_neighborhood foreign key (neighborhood_id) references app.neighborhood(neighborhood_id)
);

drop table if exists app.address;
create table app.address
(
	address_id serial,
	street_id integer,
	complement varchar(200),
	complement_ascii varchar(200),
	longitude numeric (20, 10) null,
	latitude  numeric (20, 10) null,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_address primary key (address_id),
	constraint fk_address_street foreign key (street_id) references app.street(street_id)
);

drop table if exists app.address_type;
create table app.address_type
(
	address_type_id smallserial,
	address_type_name varchar(20),
	address_type_name_ascii varchar(20),
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_address_type primary key (address_type_id)
);

drop table if exists app.client;
create table app.client
(
	client_id serial,
	client_first_name varchar(100),
	client_middle_name varchar(100) null,
	client_last_name varchar(100) null,
	cpf char(13) null,
	rg  varchar(100) null,
	date_of_birth date null,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_client primary key (client_id)
);

drop table if exists app.client_address;
create table app.client_address
(
	client_id integer,
	address_id integer,
	address_type_id smallint,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_client_address primary key (client_id, address_id, address_type_id),
	constraint fk_client_address_client foreign key (client_id) references app.client(client_id),
	constraint fk_client_address_address foreign key (address_id) references app.address(address_id),
	constraint fk_client_address_address_type foreign key (address_type_id) references app.address_type(address_type_id)
);




