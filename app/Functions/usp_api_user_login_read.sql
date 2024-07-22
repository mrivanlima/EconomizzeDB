DROP FUNCTION IF EXISTS app.usp_api_user_login_read(VARCHAR(100));
CREATE OR REPLACE FUNCTION app.usp_api_user_login_read(p_username VARCHAR(100))
RETURNS TABLE (
    out_user_id INTEGER,
    out_password_hash VARCHAR(100),
    out_password_salt VARCHAR(100),
    out_is_verified BOOLEAN,
    out_is_locked BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT user_id,
           password_hash,
           password_salt,
           is_verified,
           is_locked
    FROM app.user_login
    WHERE username = p_username
    AND is_active = TRUE;
END;
$$ LANGUAGE plpgsql;
