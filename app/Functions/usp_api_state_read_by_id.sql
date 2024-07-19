

CREATE OR REPLACE FUNCTION app.usp_api_state_read_by_id
(
    p_state_id SMALLINT
)
RETURNS app.state_record AS $$

DECLARE 
    state app.state_record;
BEGIN

    SELECT state_id,
           state_name, 
           longitude,
           latitude,
           state_uf
    INTO state
    FROM app.state
    WHERE state_id = p_state_id
	LIMIT 1;

    RETURN state;
END;
$$ LANGUAGE plpgsql;