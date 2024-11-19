CREATE TABLE app.store (
    store_id SERIAL,
    store_type_id SMALLINT,
    store_unique_id UUID NOT NULL,
    sanitized_cnpj VARCHAR(20) NOT NULL,
    cnpj VARCHAR(20) NOT NULL,
    store_name VARCHAR(100) NOT NULL,
    store_name_ascii VARCHAR(100) NOT NULL,
    is_active BOOLEAN NOT NULL,
    created_by INT NOT NULL,
    created_on TIMESTAMPTZ NOT NULL,
    modified_by INT NOT NULL,
    modified_on TIMESTAMPTZ NOT NULL,

    constraint pk_store primary key (store_id),
    constraint uk_store_unique unique (store_unique_id),
    constraint uk_store_cnpj unique (cnpj),
	constraint fk_state_created_by foreign key (created_by) references app.user_login(user_id),
    constraint fk_store_type foreign key (store_type_id) references app.store_type(store_type_id),
	constraint fk_state_modified_by foreign key (modified_by) references app.user_login(user_id)
);