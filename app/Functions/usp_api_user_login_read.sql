DROP FUNCTION IF EXISTS app.usp_api_user_login_read(VARCHAR(100));
CREATE OR REPLACE FUNCTION app.usp_api_user_login_read(p_username VARCHAR(100))
RETURNS SETOF app.user_login_record
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        user_id,
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
    WHERE username = p_username
    AND is_active = TRUE
    LIMIT 1;
END; 
$$ LANGUAGE plpgsql;