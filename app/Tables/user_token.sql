create table app.user_token
(
	user_id integer,
	token uuid default uuid_generate_v4(),
	token_start_date timestamp,
	token_expiration_date timestamp,
	is_active boolean,
	created_by integer null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user_token primary key (user_id),
	constraint fk_user_token_user foreign key (user_id) references app.user(user_id),
	constraint fk_user_token_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_user_token_modified_by foreign key (modified_by) references app.user_login(user_id)
);