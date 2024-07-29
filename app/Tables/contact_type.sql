create table app.contact_type
(
	contact_type_id   smallserial,
	contact_type_name varchar(20),
	contact_type_name_ascii varchar(20),
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_contact_type primary key (contact_type_id),
	constraint uk_contact_type_name_ascii unique (contact_type_name_ascii),
	constraint fk_contact_type_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_contact_type_modified_by foreign key (modified_by) references app.user_login(user_id)
);


