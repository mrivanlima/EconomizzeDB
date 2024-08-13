ALTER SEQUENCE app.user_login_user_id_seq MINVALUE 0;
ALTER SEQUENCE app.user_login_user_id_seq RESTART WITH 0;
INSERT INTO app.user_login (
    user_unique_id, 
    username, 
    password_hash, 
    password_salt, 
    is_verified, 
    is_active, 
    is_locked, 
    password_attempts, 
    changed_initial_password, 
    locked_time, 
    created_by, 
    created_on, 
    modified_by, 
    modified_on
) VALUES (
    uuid_generate_v4(),  -- Generate a new UUID
    'System', 
    'To be determined', 
    'To be determined', 
    true,  -- is_verified
    true,  -- is_active
    false,  -- is_locked
    0,  -- password_attempts
    true,  -- changed_initial_password
    NULL,  -- locked_time
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);





INSERT INTO app.user_login (
    user_unique_id, 
    username, 
    password_hash, 
    password_salt, 
    is_verified, 
    is_active, 
    is_locked, 
    password_attempts, 
    changed_initial_password, 
    locked_time, 
    created_by, 
    created_on, 
    modified_by, 
    modified_on
) VALUES (
    '886e1d01-55b5-4797-b803-633a2083e665',  -- Generate a new UUID
    'g@g.com', 
    '123456', 
    '123456', 
    true,  -- is_verified
    true,  -- is_active
    false,  -- is_locked
    0,  -- password_attempts
    true,  -- changed_initial_password
    NULL,  -- locked_time
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

INSERT INTO app.user_login (
    user_unique_id, 
    username, 
    password_hash, 
    password_salt, 
    is_verified, 
    is_active, 
    is_locked, 
    password_attempts, 
    changed_initial_password, 
    locked_time, 
    created_by, 
    created_on, 
    modified_by, 
    modified_on
) VALUES (
    uuid_generate_v4(),  -- Generate a new UUID
    'a@a.com', 
    '123456', 
    '123456',  
    true,  -- is_verified
    true,  -- is_active
    false,  -- is_locked
    0,  -- password_attempts
    true,  -- changed_initial_password
    NULL,  -- locked_time
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

INSERT INTO app.user_login (
    user_unique_id, 
    username, 
    password_hash, 
    password_salt, 
    is_verified, 
    is_active, 
    is_locked, 
    password_attempts, 
    changed_initial_password, 
    locked_time, 
    created_by, 
    created_on, 
    modified_by, 
    modified_on
) VALUES (
    uuid_generate_v4(),  -- Generate a new UUID
    'b@b.com', 
    '123456', 
    '123456', 
    true,  -- is_verified
    true,  -- is_active
    false,  -- is_locked
    0,  -- password_attempts
    true,  -- changed_initial_password
    NULL,  -- locked_time
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

INSERT INTO app.user_login (
    user_unique_id, 
    username, 
    password_hash, 
    password_salt, 
    is_verified, 
    is_active, 
    is_locked, 
    password_attempts, 
    changed_initial_password, 
    locked_time, 
    created_by, 
    created_on, 
    modified_by, 
    modified_on
) VALUES (
    uuid_generate_v4(),  -- Generate a new UUID
    'c@c.com', 
    '123456', 
    '123456',  
    true,  -- is_verified
    true,  -- is_active
    false,  -- is_locked
    0,  -- password_attempts
    true,  -- changed_initial_password
    NULL,  -- locked_time
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

INSERT INTO app.user (
    user_id,
    user_first_name,
    user_middle_name,
    user_last_name,
    cpf,
    rg,
    date_of_birth,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    1,  -- Replace with the actual user_id obtained
    'Test',
    'A',
    'Doe',
    '12345678901',  -- Example CPF
    'RG123456',     -- Example RG
    '1990-01-01',   -- Example date of birth
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

INSERT INTO app.user (
    user_id,
    user_first_name,
    user_middle_name,
    user_last_name,
    cpf,
    rg,
    date_of_birth,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    2,  -- Replace with the actual user_id obtained
    'John',
    'A',
    'Doe',
    '12345678901',  -- Example CPF
    'RG123456',     -- Example RG
    '1990-01-01',   -- Example date of birth
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

INSERT INTO app.user (
    user_id,
    user_first_name,
    user_middle_name,
    user_last_name,
    cpf,
    rg,
    date_of_birth,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    3,  -- Replace with the actual user_id obtained
    'Jane',
    'A',
    'Doe',
    '12345678901',  -- Example CPF
    'RG123456',     -- Example RG
    '1990-01-01',   -- Example date of birth
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

INSERT INTO app.user (
    user_id,
    user_first_name,
    user_middle_name,
    user_last_name,
    cpf,
    rg,
    date_of_birth,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    4,  -- Replace with the actual user_id obtained
    'Jane',
    'A',
    'Doe',
    '12345678901',  -- Example CPF
    'RG123456',     -- Example RG
    '1990-01-01',   -- Example date of birth
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

-- Insert Developer role
INSERT INTO app.role (
    role_name,
    role_name_ascii,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    'Developer',
    'developer',
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

-- Insert Admin role
INSERT INTO app.role (
    role_name,
    role_name_ascii,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    'Admin',
    'admin',
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

-- Insert QA role
INSERT INTO app.role (
    role_name,
    role_name_ascii,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    'QA',
    'QA',
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

-- Insert UAT role
INSERT INTO app.role (
    role_name,
    role_name_ascii,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    'UAT',
    'UAT',
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

-- Insert into app.user_role
INSERT INTO app.user_role (
    role_id,
    user_id,
    is_active,
    role_start_date,
    role_end_date,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    2,  -- role_id, matching the inserted role
    1,  -- user_id, matching the inserted user
    true,  -- is_active
    '2024-07-01 00:00:00+00',  -- role_start_date
    NULL,  -- role_end_date
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

-- Insert into app.user_role
INSERT INTO app.user_role (
    role_id,
    user_id,
    is_active,
    role_start_date,
    role_end_date,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    1,  -- role_id, matching the inserted role
    2,  -- user_id, matching the inserted user
    true,  -- is_active
    '2024-07-01 00:00:00+00',  -- role_start_date
    NULL,  -- role_end_date
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

-- Insert into app.user_role
INSERT INTO app.user_role (
    role_id,
    user_id,
    is_active,
    role_start_date,
    role_end_date,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    3,  -- role_id, matching the inserted role
    2,  -- user_id, matching the inserted user
    true,  -- is_active
    '2024-07-01 00:00:00+00',  -- role_start_date
    NULL,  -- role_end_date
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

-- Insert into app.user_role
INSERT INTO app.user_role (
    role_id,
    user_id,
    is_active,
    role_start_date,
    role_end_date,
    created_by,
    created_on,
    modified_by,
    modified_on
) VALUES (
    4,  -- role_id, matching the inserted role
    3,  -- user_id, matching the inserted user
    true,  -- is_active
    '2024-07-01 00:00:00+00',  -- role_start_date
    NULL,  -- role_end_date
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

insert into app.address_type 
(address_type_name, address_type_name_ascii, created_by, modified_by) 
VALUES
('Residência', 'Residencia', 0, 0),
('Trabalho', 'Trabalho', 0, 0),
('Outro', 'Outro', 0, 0);

insert into app.contact_type 
(contact_type_name, contact_type_name_ascii, created_by, modified_by)
values
('Email', 'Email', 0, 0),
('Telefone', 'Telefone', 0, 0);


insert into app.group (group_name, group_name_ascii, created_by, modified_by)
values
('Administrador', 'Administrador', 0, 0),
('Desenvolvedor', 'Desenvolvedor', 0, 0),
('Gerente', 'Gerente', 0, 0),
('Farmacéutico', 'Farmaceutico', 0, 0);

insert into app.product_version
(product_version_name, product_version_ascii, created_by, modified_by)
values
('Genérico', 'Generico', 0, 0),
('Similar', 'Similar', 0, 0),
('Ético', ' Ético', 0, 0);

insert into app.profession 
(profession_name, profession_name_ascii, created_by, modified_by)
values
('Médico', 'Medico', 0, 0),
('Dentista', 'Dentista', 0, 0),
('Psicólogo', 'Psicologo', 0, 0),
('Terapeuta', 'Terapeuta', 0, 0);



CALL app.usp_seed();



INSERT INTO app.state (
    state_name,
    state_name_ascii,
    state_uf,
    longitude,
    latitude,
    created_by,
    modified_by
) VALUES (
    'Example State Name',     -- state_name
    'example-state-name',     -- state_name_ascii
    'EX',                     -- state_uf (must be a 2-character string)
    -123.456,                 -- longitude (can be NULL)
    78.9012,                  -- latitude (can be NULL)
    0,                        -- created_by (must be a valid user_id in app.user_login)
    0                         -- modified_by (must be a valid user_id in app.user_login)
);