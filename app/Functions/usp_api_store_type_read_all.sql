DROP FUNCTION IF EXISTS app.usp_api_store_type_read_all;
CREATE OR REPLACE FUNCTION app.usp_api_store_type_read_all()
RETURNS TABLE (
    out_store_type_id SMALLINT,
    out_store_type_name VARCHAR(100),
    out_store_type_name_ascii VARCHAR(100),
    out_created_by INTEGER,
    out_created_on TIMESTAMPTZ,
    out_modified_by INTEGER,
    out_modified_on TIMESTAMPTZ
) 
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        store_type_id,
        store_type_name,
        store_type_name_ascii,
        created_by,
        created_on,
        modified_by,
        modified_on
    FROM app.store_type;
END;
$$ LANGUAGE plpgsql;
