DROP FUNCTION IF EXISTS app.usp_api_user_read_all();
CREATE OR REPLACE FUNCTION app.usp_api_user_read_all()
RETURNS TABLE (
    out_user_id INTEGER,
    out_user_first_name VARCHAR(100),
    out_user_middle_name VARCHAR(100),
    out_user_last_name VARCHAR(100),
    out_user_email VARCHAR(250),
    out_cpf CHAR(11),
    out_rg VARCHAR(100),
    out_date_of_birth DATE,
    out_user_unique_id UUID,
    out_created_by INTEGER,
    out_created_on TIMESTAMP WITH TIME ZONE,
    out_modified_by INTEGER,
    out_modified_on TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT user_id,
           user_first_name,
           user_middle_name,
           user_last_name,
           user_email,
           cpf,
           rg,
           date_of_birth,
           user_unique_id,
           created_by,
           created_on,
           modified_by,
           modified_on
    FROM app.user;
END;
$$ LANGUAGE plpgsql;