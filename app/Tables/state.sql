create table app.state
(
	state_id smallserial,
	state_name varchar(50) not null,
	state_name_ascii varchar(50) not null,
	state_uf         char(2) not null,
	longitude double precision null,
	latitude  double precision null,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_state primary key (state_id),
	constraint uk_state_name_asci unique (state_name_ascii),
	constraint fk_state_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_state_modified_by foreign key (modified_by) references app.user_login(user_id)
);