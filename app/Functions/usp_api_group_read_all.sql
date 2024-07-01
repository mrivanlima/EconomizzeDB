CREATE OR REPLACE FUNCTION app.usp_api_group_read_all()
RETURNS TABLE (
    out_group_id SMALLINT,
    out_group_name VARCHAR(50),
    out_group_name_ascii VARCHAR(50)
) AS $$
BEGIN
    RETURN QUERY
    SELECT group_id,
           group_name,
           group_name_ascii
    FROM app.group;
END;
$$ LANGUAGE plpgsql;