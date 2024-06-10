CREATE INDEX idx_street_zipcode
ON app.street (zipcode)
INCLUDE (street_name, street_name_ascii, street_id);


CREATE INDEX IX_USERLOGIN_USERNAME 
ON app.user_login (username)
INCLUDE(password_hash, password_salt, is_verified, is_active, is_locked, password_atempts, changed_initial_password, locked_time)  