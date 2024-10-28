create table app.quote
(
	quote_id bigserial,
	user_id integer,
	neighborhood_id integer,
	is_expired boolean default false,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_quote primary key (quote_id),
	constraint fk_quote_neighborhood foreign key (neighborhood_id) references app.neighborhood(neighborhood_id),
	constraint fk_quote_user foreign key (user_id) references app.user_login(user_id),
	constraint fk_quote_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_quote_modified_by foreign key (modified_by) references app.user_login(user_id)
);