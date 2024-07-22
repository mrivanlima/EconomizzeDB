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
    'example_username', 
    'example_password_hash', 
    'example_password_salt', 
    true,  -- is_verified
    true,  -- is_active
    false,  -- is_locked
    0,  -- password_attempts
    true,  -- changed_initial_password
    NULL,  -- locked_time
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
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
    'example_username2', 
    'example_password_hash', 
    'example_password_salt', 
    true,  -- is_verified
    true,  -- is_active
    false,  -- is_locked
    0,  -- password_attempts
    true,  -- changed_initial_password
    NULL,  -- locked_time
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
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
    'example_username3', 
    'example_password_hash', 
    'example_password_salt', 
    true,  -- is_verified
    true,  -- is_active
    false,  -- is_locked
    0,  -- password_attempts
    true,  -- changed_initial_password
    NULL,  -- locked_time
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
    current_timestamp  -- modified_on
);

INSERT INTO app.user (
    user_id,
    user_first_name,
    user_middle_name,
    user_last_name,
    user_email,
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
    'test@example.com',
    '12345678901',  -- Example CPF
    'RG123456',     -- Example RG
    '1990-01-01',   -- Example date of birth
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
    current_timestamp  -- modified_on
);

INSERT INTO app.user (
    user_id,
    user_first_name,
    user_middle_name,
    user_last_name,
    user_email,
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
    'john.doe@example.com',
    '12345678901',  -- Example CPF
    'RG123456',     -- Example RG
    '1990-01-01',   -- Example date of birth
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
    current_timestamp  -- modified_on
);

INSERT INTO app.user (
    user_id,
    user_first_name,
    user_middle_name,
    user_last_name,
    user_email,
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
    'jane.doe@example.com',
    '12345678901',  -- Example CPF
    'RG123456',     -- Example RG
    '1990-01-01',   -- Example date of birth
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
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
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
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
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
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
    'qa',
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
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
    'uat',
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
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
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
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
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
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
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
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
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
    current_timestamp  -- modified_on
);

CALL app.usp_seed();