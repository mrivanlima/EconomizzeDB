create table app.user_password_reset
(
	user_id int,
	user_token uuid,
	token_expiry smallint not null default 10,
	already_used boolean default false,
	created_by integer null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user_password_reset primary key (user_id),
	constraint uq_user_token unique (user_token),
    constraint fk_user_password_reset_user foreign key (user_id) references app.user_login(user_id),
	constraint fk_user_password_reset_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_user_password_reset_modified_by foreign key (modified_by) references app.user_login(user_id)
    constraint ck_token_expiry CHECK (token_expiry <= 10)
);