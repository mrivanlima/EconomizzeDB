
DROP FUNCTION IF EXISTS app.usp_api_state_read_by_id;
CREATE OR REPLACE FUNCTION app.usp_api_state_read_by_id
(
    p_state_id SMALLINT
)
RETURNS SETOF app.state_record AS $$
BEGIN

    RETURN QUERY
    SELECT state_id,
           state_name, 
           longitude,
           latitude,
           state_uf
    FROM app.state
    WHERE state_id = p_state_id
	LIMIT 1;

END;
$$ LANGUAGE plpgsql;