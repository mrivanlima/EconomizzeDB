create table app.role
(
	role_id   smallserial,
	role_name varchar(50),
	role_name_ascii varchar(50),
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_role primary key (role_id),
	constraint uk_role_name_ascii unique (role_name_ascii),
	constraint fk_role_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_role_modified_by foreign key (modified_by) references app.user_login(user_id)
);