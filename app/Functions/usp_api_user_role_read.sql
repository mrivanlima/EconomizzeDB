-----------------------------------------------------------------
--Create function to read user roles with joined role and user details
-----------------------------------------------------------------
DROP FUNCTION IF EXISTS app.usp_api_user_role_read;
CREATE OR REPLACE FUNCTION app.usp_api_user_role_read(
    p_user_id INTEGER
)
RETURNS TABLE (
    role_name VARCHAR(50)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.role_name
    FROM app.user u
        JOIN app.user_role ur 
            ON ur.user_id = u.user_id
            AND ur.is_active = true
        JOIN app.role r 
            ON ur.role_id = r.role_id
    WHERE u.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;
