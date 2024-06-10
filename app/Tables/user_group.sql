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