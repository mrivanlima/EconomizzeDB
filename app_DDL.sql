create schema if not exists app;
create schema if not exists imp;
CREATE EXTENSION IF NOT EXISTS unaccent;

CALL app.drop_foreign_keys();

drop table if exists app.error_log;

CREATE TABLE app.error_log (
    error_log_id bigserial,
    error_on timestamp with time zone default current_timestamp,
    error_message text,
    error_code varchar(100),
	error_line text,
	constraint pk_error_log primary key (error_log_id)
);

drop table if exists app.state;
create table app.state
(
	state_id smallserial,
	state_name varchar(50) not null,
	state_name_ascii varchar(50) not null,
	state_uf         char(2) not null,
	longitude double precision null,
	latitude  double precision null,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_state primary key (state_id)
);


drop table if exists app.city;
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

drop table if exists app.neighborhood;
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
	constraint fk_neighborhood_city foreign key (city_id) references app.city(city_id)
);

drop table if exists app.street;
create table app.street
(
	street_id serial,
	street_name varchar(50) not null,
	street_name_ascii varchar(50) not null,
	zipcode char(8),
	longitude double precision null,
	latitude  double precision null,
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
	longitude double precision null,
	latitude  double precision null,
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

drop table if exists app.user;
create table app.user
(
	user_id serial,
	user_first_name varchar(100),
	user_middle_name varchar(100) null,
	user_last_name varchar(100) null,
	user_email varchar(250) not null,
	cpf char(11) null,
	rg  varchar(100) null,
	date_of_birth date null,
	created_by integer null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user primary key (user_id),
	constraint uk_user_email unique (user_email)
);

drop table if exists app.user_login;
create table app.user_login
(
	user_id integer,
	username varchar(100) not null,
	password_hash varchar(100) not null,
	password_salt varchar(100) not null,
	is_verified boolean default false,
	is_active boolean default false,
	is_locked boolean default false,
	password_atempts smallint default 0,
	changed_initial_password boolean default false,
	locked_time timestamp with time zone,
	created_by integer null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user_login primary key (user_id),
	constraint fk_user_login_user foreign key (user_id) references app.user(user_id)
);

drop table if exists app.user_address;
create table app.user_address
(
	user_id integer,
	address_id integer,
	address_type_id smallint,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user_address primary key (user_id, address_id, address_type_id),
	constraint fk_user_address_user foreign key (user_id) references app.user(user_id),
	constraint fk_user_address_address foreign key (address_id) references app.address(address_id),
	constraint fk_user_address_address_type foreign key (address_type_id) references app.address_type(address_type_id)
);

drop table if exists app.drugstore;
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

drop table if exists app.drugstore_neighborhood_subscription;
create table app.drugstore_neighborhood_subscription
(
	drugstore_id integer,
	neighborhood_id integer,
	is_active boolean,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_drugstore_neighborhood_subscription primary key (drugstore_id, neighborhood_id),
	constraint fk_drugstore_neighborhood_subscription_neighborhood foreign key (neighborhood_id) references app.neighborhood(neighborhood_id),
	constraint fk_drugstore_neighborhood_subscription_drugstore foreign key (drugstore_id) references app.drugstore(drugstore_id)
);

drop table if exists app.quote;
create table app.quote
(
	quote_id bigserial,
	user_id integer,
	neighborhood_id integer,
	prescription_url varchar(256),
	is_expired boolean default false,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_quote primary key (quote_id),
	constraint fk_quote_neighborhood foreign key (neighborhood_id) references app.neighborhood(neighborhood_id),
	constraint fk_quote_user foreign key (user_id) references app.user(user_id)
);

drop table if exists app.product;
create table app.product
(
	product_id serial,
	product_name varchar(200),
	product_name_ascii varchar(200),
	product_concentration varchar(20),
	Product_quantity smallint,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_product primary key (product_id)
);

drop table if exists app.quote_product;
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

drop table if exists app.role;
create table app.role
(
	role_id   smallserial,
	role_name varchar(50),
	role_name_ascii varchar(50),
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_role primary key (role_id)
);

drop table if exists app.user_role;
create table app.user_role
(
	role_id   smallint,
	user_id   integer,
	is_active boolean default true,
	role_start_date timestamp with time zone,
	role_end_date timestamp with time zone,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user_role primary key (role_id, user_id),
	constraint fk_user_role_role foreign key (role_id) references app.role(role_id),
	constraint fk_user_role_user foreign key (user_id) references app.user(user_id)
);

drop table if exists app.group;
create table app.group
(
	group_id   smallserial,
	group_name varchar(50),
	group_name_ascii varchar(50),
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_group primary key (group_id)
);

drop table if exists app.user_group;
create table app.user_group
(
	group_id   smallint,
	user_id   integer,
	is_active boolean default true,
	group_start_date timestamp with time zone,
	group_end_date timestamp with time zone,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user_group primary key (group_id, user_id),
	constraint fk_user_group_group foreign key (group_id) references app.group(group_id),
	constraint fk_user_group_user foreign key (user_id) references app.user(user_id)
);


--This is for Generic, Similar or Original only
drop table if exists app.product_version;
create table app.product_version
(
	product_version_id   smallint,
	product_version_name   varchar(20),
	product_version_ascii   varchar(20),
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_product_version primary key (product_version_id)
);

drop table if exists app.quote_response;
create table app.quote_response
(
	quote_id   bigint,
	drugstore_id integer,
	product_version_id integer,
	total_price numeric(10, 2),
	discount_percentage numeric(10, 2),
	total_final_price numeric(10, 2),
	is_active boolean default true,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_quote_response primary key (quote_id, drugstore_id, product_version_id),
	constraint fk_quote_response_quote foreign key (quote_id) references app.quote(quote_id),
	constraint fk_quote_response_drugstore foreign key (drugstore_id) references app.drugstore(drugstore_id),
	constraint fk_quote_response_product_version foreign key (product_version_id) references app.product_version(product_version_id)
);

drop table if exists app.quote_product_response;
create table app.quote_product_response
(
	quote_id   bigint,
	product_id integer,
	drugstore_id integer,
	product_version_id integer,
	regular_price numeric(10, 2),
	discount_percentage numeric(10, 2),
	final_price numeric(10, 2),
	is_active boolean default true,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_quote_product_response primary key (quote_id, product_id, drugstore_id, product_version_id),
	constraint fk_quote_product_response_quote foreign key (quote_id) references app.quote(quote_id),
	constraint fk_quote_product_response_product foreign key (product_id) references app.product(product_id),
	constraint fk_quote_product_response_drugstore foreign key (drugstore_id) references app.drugstore(drugstore_id),
	constraint fk_quote_product_response_product_version foreign key (product_version_id) references app.product_version(product_version_id)
);

drop table if exists app.contact_type;
create table app.contact_type
(
	contact_type_id   smallserial,
	contact_type_name varchar(20),
	contact_type_name_ascii varchar(20),
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_contact_type primary key (contact_type_id)
);
