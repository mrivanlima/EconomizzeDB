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
	constraint fk_user_role_user foreign key (user_id) references app.user(user_id),
	constraint fk_user_role_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_user_role_modified_by foreign key (modified_by) references app.user_login(user_id)
);