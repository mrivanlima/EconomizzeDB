create schema if not exists app;

CREATE OR REPLACE FUNCTION drop_all_foreign_keys() RETURNS VOID AS $$
DECLARE
    fk_record RECORD;
    drop_stmt TEXT;
BEGIN
    FOR fk_record IN (
        SELECT conrelid::regclass AS table_from,
               conname AS constraint_def
        FROM pg_constraint
        WHERE contype = 'f'
    )
    LOOP
        drop_stmt := 'ALTER TABLE ' || fk_record.table_from || ' DROP CONSTRAINT ' || quote_ident(fk_record.constraint_def);
        raise notice 'Droping FK %', drop_stmt;
        EXECUTE drop_stmt;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

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



