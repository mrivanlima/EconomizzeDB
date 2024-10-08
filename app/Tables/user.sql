create table app.user
(
	user_id integer,
	user_first_name varchar(100),
	user_middle_name varchar(100) null,
	user_last_name varchar(100) null,
	cpf char(11) null,
	rg  varchar(100) null,
	date_of_birth date null,  
	phone_number VARCHAR(15) null, 
	created_by integer null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user primary key (user_id),
	constraint fk_user_login_user foreign key (user_id) references app.user_login(user_id),
	constraint fk_user_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_user_modified_by foreign key (modified_by) references app.user_login(user_id)
);