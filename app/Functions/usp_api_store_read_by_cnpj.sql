-- Drop the procedure if it already exists
DROP FUNCTION IF EXISTS app.usp_api_store_read_by_cnpj;
CREATE OR REPLACE FUNCTION app.usp_api_store_read_by_cnpj(input_cnpj VARCHAR)
RETURNS TABLE (
    store_id INT,
    store_type_id SMALLINT,
    store_unique_id UUID,
    cnpj VARCHAR,
    store_name VARCHAR,
    store_name_ascii VARCHAR,
    is_active BOOLEAN,
    created_by INT,
    created_on TIMESTAMPTZ,
    modified_by INT,
    modified_on TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        store_id,
        store_type_id,
        store_unique_id,
        cnpj,
        store_name,
        store_name_ascii,
        is_active,
        created_by,
        created_on,
        modified_by,
        modified_on
    FROM app.store
    WHERE cnpj = input_cnpj;
END;
$$ LANGUAGE plpgsql;
