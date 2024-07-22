
CREATE OR REPLACE FUNCTION app.usp_api_state_read_all()
RETURNS SETOF app.state_record 
AS $$
BEGIN
    RETURN QUERY
    SELECT state_id,
           state_name,
           longitude,
           latitude,
           state_uf
    FROM app.state;
END;
$$ LANGUAGE plpgsql;