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
