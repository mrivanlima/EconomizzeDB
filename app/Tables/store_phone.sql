CREATE TABLE app.store_phone (
    store_phone_id SERIAL,
    store_id INT NOT NULL,
    country_code VARCHAR(5) ,
    state_code VARCHAR(5) ,
    phone_number VARCHAR(20),
    phone_national_format VARCHAR(30),
    phone_human_format VARCHAR(30) ,
    phone_164_format VARCHAR(20), 
    is_main BOOLEAN,
    is_active BOOLEAN,
    is_whatsapp BOOLEAN,
    created_by INT NOT NULL,
    created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by INT,
    modified_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_store_phone PRIMARY KEY (store_phone_id),
    CONSTRAINT fk_store_phone_store FOREIGN KEY (store_id) REFERENCES app.store(store_id)
);
