CREATE TABLE app.store_type (
    store_type_id SMALLSERIAL,
    store_type_name VARCHAR(100) NOT NULL,
    store_type_name_ascii VARCHAR(100) NOT NULL,
    created_by INTEGER NOT NULL,
    created_on TIMESTAMPTZ NOT NULL,
    modified_by INTEGER NOT NULL,
    modified_on TIMESTAMPTZ NOT NULL,

     constraint pk_store_type primary key (store_type_id),
    constraint uk_store_type_name_unique unique (store_type_name)
);
