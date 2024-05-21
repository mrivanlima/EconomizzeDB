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

drop table if exists app.customer;
create table app.customer
(
	customer_id serial,
	customer_first_name varchar(100),
	customer_middle_name varchar(100) null,
	customer_last_name varchar(100) null,
	cpf char(13) null,
	rg  varchar(100) null,
	date_of_birth date null,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_customer primary key (customer_id)
);

drop table if exists app.customer_login;
create table app.customer_login
(
	customer_id integer,
	username varchar(100),
	password varchar(100),
	password_hash varchar(100),
	password_salt varchar(100),
	is_verified boolean default false,
	is_active boolean default false,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_customer_login primary key (customer_id),
	constraint fk_customer_login_customer foreign key (customer_id) references app.customer(customer_id)
);

drop table if exists app.customer_address;
create table app.customer_address
(
	customer_id integer,
	address_id integer,
	address_type_id smallint,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_customer_address primary key (customer_id, address_id, address_type_id),
	constraint fk_customer_address_customer foreign key (customer_id) references app.customer(customer_id),
	constraint fk_customer_address_address foreign key (address_id) references app.address(address_id),
	constraint fk_customer_address_address_type foreign key (address_type_id) references app.address_type(address_type_id)
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
	customer_id integer,
	neighborhood_id integer,
	is_expired boolean default false,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_quote primary key (quote_id),
	constraint fk_quote_neighborhood foreign key (neighborhood_id) references app.neighborhood(neighborhood_id),
	constraint fk_quote_customer foreign key (customer_id) references app.customer(customer_id)
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




