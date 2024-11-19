-- Drop the function if it already exists
DROP FUNCTION IF EXISTS app.usp_api_store_type_by_id;

-- Create or replace the function
CREATE OR REPLACE FUNCTION app.usp_api_store_type_by_id(p_store_type_id INT)
RETURNS TABLE (
    store_type_id SMALLINT,
    store_type_name VARCHAR(100),
    store_type_name_ascii VARCHAR(100),
    created_by INTEGER,
    created_on TIMESTAMPTZ,
    modified_by INTEGER,
    modified_on TIMESTAMPTZ
) 
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        st.store_type_id,
        st.store_type_name,
        st.store_type_name_ascii,
        st.created_by,
        st.created_on,
        st.modified_by,
        st.modified_on
    FROM app.store_type AS st
    WHERE st.store_type_id = p_store_type_id;
END;
$$ LANGUAGE plpgsql;
