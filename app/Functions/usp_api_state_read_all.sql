CREATE OR REPLACE FUNCTION app.usp_api_state_read_all()
RETURNS TABLE (
    out_state_id SMALLINT,
    out_state_name VARCHAR(50),
    out_longitude DOUBLE PRECISION,
    out_latitude DOUBLE PRECISION,
    out_state_uf CHAR(2)
) AS $$
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