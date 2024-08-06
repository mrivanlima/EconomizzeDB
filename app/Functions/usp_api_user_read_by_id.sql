DROP FUNCTION IF EXISTS app.usp_api_user_read_by_id;
CREATE OR REPLACE FUNCTION app.usp_api_user_read_by_id
(
    p_user_id INTEGER
)
RETURNS SETOF app.user_record AS $$
BEGIN

    RETURN QUERY
    SELECT user_id,
           user_first_name, 
           user_middle_name,
           user_last_name,
           cpf,
           rg,
           date_of_birth
    FROM app.user
    WHERE user_id = p_user_id
	LIMIT 1;

END;
$$ LANGUAGE plpgsql;