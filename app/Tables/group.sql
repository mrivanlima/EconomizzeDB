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
