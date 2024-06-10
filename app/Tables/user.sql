create table app.user
(
	user_id serial,
	user_first_name varchar(100),
	user_middle_name varchar(100) null,
	user_last_name varchar(100) null,
	user_email varchar(250) not null,
	cpf char(11) null,
	rg  varchar(100) null,
	date_of_birth date null,
	user_unique_id uuid,  
	created_by integer null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_user primary key (user_id),
	constraint uk_user_email unique (user_email)
);