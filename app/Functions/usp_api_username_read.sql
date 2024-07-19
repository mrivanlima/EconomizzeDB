DROP FUNCTION IF EXISTS app.usp_api_username_read();
CREATE OR REPLACE FUNCTION app.usp_api_username_read()
RETURNS TABLE (
    out_username VARCHAR(100),
    out_is_active BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT username,
           is_active
    FROM app.user_login;
END;
$$ LANGUAGE plpgsql;
