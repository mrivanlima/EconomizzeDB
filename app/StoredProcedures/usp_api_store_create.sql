DROP PROCEDURE IF EXISTS app.usp_api_store_create;
CREATE OR REPLACE PROCEDURE app.usp_api_store_create(
    OUT p_out_store_id INTEGER,
    OUT p_out_message VARCHAR(100),
    IN p_store_type_id SMALLINT,
    IN p_store_unique_id UUID,
    IN p_cnpj VARCHAR(20),
    IN p_store_name VARCHAR(100),
    IN p_is_active BOOLEAN,
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    OUT p_error BOOLEAN
)
AS $$
DECLARE
    v_store_name_ascii VARCHAR(100);
    l_context TEXT;
    v_created_on TIMESTAMPTZ;
BEGIN
    -- Trim and convert the store name to ASCII
    p_store_name := TRIM(p_store_name);
    v_store_name_ascii := unaccent(p_store_name);
    v_created_on := NOW();
    p_error := false;

    -- Begin block to handle exceptions
    BEGIN
        -- Insert the new store record
        INSERT INTO app.store 
        (
            store_unique_id,
            store_type_id,
            cnpj,
            store_name,
            store_name_ascii,
            is_active,
            created_by,
            created_on,
            modified_by,
            modified_on
        )
        VALUES 
        (
            p_store_unique_id,
            p_store_type_id,
            p_cnpj,
            p_store_name,
            v_store_name_ascii,
            p_is_active,
            p_created_by,
            v_created_on,
            p_modified_by,
            v_created_on
        )
        RETURNING store_id INTO p_out_store_id;

    EXCEPTION
        WHEN OTHERS THEN
            -- Set the error flag to true
            p_error := TRUE;

            -- Get exception context
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;

            -- Log the error in the error_log table
            INSERT INTO app.error_log 
            (
                error_message, 
                error_code, 
                error_line
            )
            VALUES 
            (
                SQLERRM, 
                SQLSTATE, 
                l_context
            );
    END;
END;
$$
LANGUAGE plpgsql;
