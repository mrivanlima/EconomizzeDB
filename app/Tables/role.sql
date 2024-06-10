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