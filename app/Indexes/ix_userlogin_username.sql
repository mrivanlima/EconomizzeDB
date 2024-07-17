CREATE INDEX ix_userlogin_username 
ON app.user_login (username)
INCLUDE(user_unique_id, password_hash, password_salt, is_verified, is_active, is_locked, password_attempts, changed_initial_password, locked_time) 