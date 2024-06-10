create table app.drugstore_neighborhood_subscription
(
	drugstore_id integer,
	neighborhood_id integer,
	is_active boolean,
	created_by integer not null,
	created_on 	timestamp with time zone default current_timestamp,
	modified_by integer not null,
	modified_on timestamp with time zone default current_timestamp,
	constraint pk_drugstore_neighborhood_subscription primary key (drugstore_id, neighborhood_id),
	constraint fk_drugstore_neighborhood_subscription_neighborhood foreign key (neighborhood_id) references app.neighborhood(neighborhood_id),
	constraint fk_drugstore_neighborhood_subscription_drugstore foreign key (drugstore_id) references app.drugstore(drugstore_id)
);