DROP FUNCTION IF EXISTS app.usp_api_store_read_read_by_id;

CREATE OR REPLACE FUNCTION app.usp_api_store_read_by_id(
    p_store_id INTEGER
)
RETURNS TABLE (
    store_id INTEGER,
    store_type_id SMALLINT,
    store_unique_id UUID,
    cnpj VARCHAR(20),
    store_name VARCHAR(100),
    store_name_ascii VARCHAR(100),
    is_active BOOLEAN,
    created_by INTEGER,
    created_on TIMESTAMPTZ,
    modified_by INTEGER,
    modified_on TIMESTAMPTZ
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.store_id,
        s.store_type_id,
        s.store_unique_id,
        s.cnpj,
        s.store_name,
        s.store_name_ascii,
        s.is_active,
        s.created_by,
        s.created_on,
        s.modified_by,
        s.modified_on
    FROM app.store s
    WHERE s.store_id = p_store_id;
END;
$$ LANGUAGE plpgsql;
