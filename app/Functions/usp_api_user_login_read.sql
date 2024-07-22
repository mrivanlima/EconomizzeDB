DROP FUNCTION IF EXISTS app.usp_api_user_login_read(VARCHAR(100));
CREATE OR REPLACE FUNCTION app.usp_api_user_login_read(p_username VARCHAR(100))
RETURNS app.user_login_record
AS $$
DECLARE
    user_login app.user_login_record;
BEGIN
    SELECT user_id,
           user_unique_id,
           username,
           password_hash,
           password_salt,
           is_verified,
           is_active,
           is_locked
    INTO user_login
    FROM app.user_login
    WHERE username = p_username
    AND is_active = TRUE;

    RETURN user_login;
END; 
$$ LANGUAGE plpgsql;