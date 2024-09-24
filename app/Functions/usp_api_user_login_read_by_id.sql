DROP FUNCTION IF EXISTS app.usp_api_user_login_read_by_id;
CREATE OR REPLACE FUNCTION app.usp_api_user_login_read_by_id
(
    p_user_id INTEGER
)
RETURNS SETOF app.user_login_record AS $$
BEGIN

    RETURN QUERY
    SELECT user_id,
           user_unique_id, 
           username,
           password_hash,
           password_salt,
           is_verified,
           is_active,
           is_locked,
           password_attempts,
           changed_initial_password
    FROM app.user_login
    WHERE user_id = p_user_id
	LIMIT 1;

END;
$$ LANGUAGE plpgsql;