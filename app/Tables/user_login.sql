create table app.user_login
(
	user_id integer,
	username varchar(100) not null,
	password_hash varchar(100) not null,
	password_salt varchar(100) not null,
	is_verified boolean default false,
	is_active boolean default false,
	is_locked boolean default false,
	password_attempts smallint default 0,
	changed_initial_password boolean default false,
	locked_time timestamp with time zone,
	created_by integer null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user_login primary key (user_id),
	constraint fk_user_login_user foreign key (user_id) references app.user(user_id)
);