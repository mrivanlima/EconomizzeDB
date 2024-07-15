DROP FUNCTION IF EXISTS app.usp_api_user_login_read_all();
CREATE OR REPLACE FUNCTION app.usp_api_user_login_read_all()
RETURNS TABLE (
    out_user_id INTEGER,
    out_username VARCHAR(100),
    out_password_hash VARCHAR(100),
    out_password_salt VARCHAR(100),
    out_is_verified BOOLEAN,
    out_is_active BOOLEAN,
    out_is_locked BOOLEAN,
    out_password_attempts SMALLINT,
    out_changed_initial_password BOOLEAN,
    out_locked_time TIMESTAMP WITH TIME ZONE,
    out_created_by INTEGER,
    out_created_on TIMESTAMP WITH TIME ZONE,
    out_modified_by INTEGER,
    out_modified_on TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT user_id,
           username,
           password_hash,
           password_salt,
           is_verified,
           is_active,
           is_locked,
           password_attempts,
           changed_initial_password,
           locked_time,
           created_by,
           created_on,
           modified_by,
           modified_on
    FROM app.user_login;
END;
$$ LANGUAGE plpgsql;
