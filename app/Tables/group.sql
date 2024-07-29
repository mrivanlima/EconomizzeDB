create table app.group
(
	group_id   smallserial,
	group_name varchar(50),
	group_name_ascii varchar(50),
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_group primary key (group_id),
	constraint uk_group_name_ascii unique (group_name_ascii),
	constraint fk_group_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_group_modified_by foreign key (modified_by) references app.user_login(user_id)
);


