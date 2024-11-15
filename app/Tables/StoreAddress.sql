

CREATE TABLE app.store_address (
    store_address_id SERIAL,
    store_id INT NOT NULL,
    street_id INT,
    number VARCHAR(50) NOT NULL,
    complement VARCHAR(100) DEFAULT '',
    complement_ascii VARCHAR(100) DEFAULT '',
    longitude DOUBLE PRECISION,
    latitude DOUBLE PRECISION,
    created_by INT NOT NULL,
    created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by INT NOT NULL,
    modified_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    constraint pk_store_address primary key (store_address_id),
    constraint fk_store_address_store foreign key (created_by) references app.user_login(user_id),
	constraint fk_store_address_street foreign key (modified_by) references app.user_login(user_id)
	constraint fk_store_address_created_by foreign key (created_by) references app.user_login(user_id),
	constraint fk_store_address_modified_by foreign key (modified_by) references app.user_login(user_id)
);