DROP VIEW IF EXISTS app.v_user_login_details;
CREATE OR REPLACE VIEW app.v_user_login_details AS
SELECT ul.username,
	   ul.password_hash,
	   ul.password_salt,
	   ul.is_verified,
	   ul.is_active,
	   ul.is_locked,
	   ul.password_attempts,
	   ul.changed_initial_password,
	   ul.locked_time,
	   u.user_id,
	   u.user_first_name,
	   u.user_middle_name,
	   u.user_last_name,
	   u.user_email,
	   u.cpf,
	   u.rg,
	   u.date_of_birth
	
FROM app.user_login ul
	JOIN app.user u
		ON u.user_id = ul.user_id;