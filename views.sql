DROP VIEW IF EXISTS app.v_street_details;
CREATE OR REPLACE VIEW app.v_street_details AS
SELECT s.street_id,
	   s.street_name,
       s.street_name_ascii,
	   s.zipcode,
       n.neighborhood_name,
       c.city_name,
       st.state_name
	   
FROM app.street s
JOIN app.neighborhood n
    ON n.neighborhood_id = s.neighborhood_id
JOIN app.city c
    ON c.city_id = n.city_id
JOIN app.state st
    ON st.state_id = c.state_id;


DROP VIEW IF EXISTS app.v_user_login_details;
CREATE OR REPLACE VIEW app.v_user_login_details AS
SELECT ul.username,
	   ul.password_hash,
	   ul.password_salt,
	   ul.is_verified,
	   ul.is_active,
	   ul.is_locked,
	   ul.password_atempts,
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