DROP FUNCTION IF EXISTS app.usp_api_username_read(VARCHAR(100));
CREATE OR REPLACE FUNCTION app.usp_api_username_read(p_username VARCHAR(100))
RETURNS TABLE (
    out_password_hash VARCHAR(100),
    out_password_salt VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT password_hash,
           password_salt
    FROM app.user_login
    WHERE password_hash = p_password_hash
    AND password_salt = p_password_salt;
END;
$$ LANGUAGE plpgsql;
