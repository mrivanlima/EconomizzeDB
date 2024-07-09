DROP FUNCTION IF EXISTS app.usp_api_profession_read_all();
CREATE OR REPLACE FUNCTION app.usp_api_profession_read_all()
RETURNS TABLE (
    out_profession_id SMALLINT,
    out_profession_name VARCHAR(20),
    out_profession_name_ascii VARCHAR(20),
    out_created_by INTEGER,
    out_created_on TIMESTAMP WITH TIME ZONE,
    out_modified_by INTEGER,
    out_modified_on TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT profession_id,
           profession_name,
           profession_name_ascii,
           created_by,
           created_on,
           modified_by,
           modified_on
    FROM app.profession;
END;
$$ LANGUAGE plpgsql;