DROP FUNCTION IF EXISTS app.usp_api_group_read_all();
CREATE OR REPLACE FUNCTION app.usp_api_group_read_all()
RETURNS TABLE (
    out_group_id SMALLINT,
    out_group_name VARCHAR(50),
    out_group_name_ascii VARCHAR(50),
    out_created_by INTEGER,
    out_created_on TIMESTAMP WITH TIME ZONE,
    out_modified_by INTEGER,
    out_modified_on TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT group_id,
           group_name,
           group_name_ascii,
           created_by,
           created_on,
           modified_by,
           modified_on
    FROM app.group;
END;
$$ LANGUAGE plpgsql;