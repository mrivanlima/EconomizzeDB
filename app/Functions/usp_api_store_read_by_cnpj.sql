-- Drop the function if it already exists
DROP FUNCTION IF EXISTS app.usp_api_store_read_by_cnpj;

-- Create or replace the function
CREATE OR REPLACE FUNCTION app.usp_api_store_read_by_cnpj(p_sanitized_cnpj VARCHAR)
RETURNS TABLE (
    store_id INT,
    store_type_id SMALLINT,
    store_unique_id UUID,
    cnpj VARCHAR,
    sanitized_cnpj VARCHAR,
    store_name VARCHAR,
    store_name_ascii VARCHAR,
    is_active BOOLEAN,
    created_by INT,
    created_on TIMESTAMPTZ,
    modified_by INT,
    modified_on TIMESTAMPTZ
) 
AS $$
BEGIN
    -- Ensure that we return the query with fully qualified table names
    RETURN QUERY
    SELECT 
        s.store_id,
        s.store_type_id,
        s.store_unique_id,
        s.cnpj,
        s.sanitized_cnpj,
        s.store_name,
        s.store_name_ascii,
        s.is_active,
        s.created_by,
        s.created_on,
        s.modified_by,
        s.modified_on
    FROM app.store AS s
    WHERE s.sanitized_cnpj = p_sanitized_cnpj;
END;
$$ LANGUAGE plpgsql;