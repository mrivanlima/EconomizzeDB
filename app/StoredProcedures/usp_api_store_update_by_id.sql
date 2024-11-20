DROP PROCEDURE IF EXISTS app.usp_api_store_update_by_id;

CREATE OR REPLACE PROCEDURE app.usp_api_store_update_by_id(
    IN p_store_id INTEGER,
    IN p_store_type_id SMALLINT,
    IN p_cnpj VARCHAR(20),
    IN p_sanitized_cnpj VARCHAR(20),
    IN p_store_name VARCHAR(100),
    IN p_is_active BOOLEAN,
    IN p_modified_by INTEGER,
    OUT p_out_message VARCHAR,
    OUT p_error BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_store_name_ascii VARCHAR(100);
    l_context TEXT;
    v_created_on TIMESTAMPTZ := NOW();
    v_trimmed_store_name VARCHAR(100);
    v_trimmed_cnpj VARCHAR(20);
    v_trimmed_sanitized_cnpj VARCHAR(20);
BEGIN
    -- Trim and convert inputs
    v_trimmed_store_name := TRIM(p_store_name);
    v_trimmed_cnpj := TRIM(p_cnpj);
    v_store_name_ascii := unaccent(v_trimmed_store_name);
    v_trimmed_sanitized_cnpj := TRIM(p_sanitized_cnpj);

    -- Check if the store exists
    IF EXISTS (SELECT 1 FROM app.store WHERE store_id = p_store_id) THEN
        BEGIN
            -- Update the store record
            UPDATE app.store
            SET
                store_type_id = p_store_type_id,
                cnpj = v_trimmed_cnpj,
                sanitized_cnpj = v_trimmed_sanitized_cnpj,
                store_name = v_trimmed_store_name,
                store_name_ascii = v_store_name_ascii,
                is_active = p_is_active,
                modified_by = p_modified_by,
                modified_on = v_created_on
            WHERE store_id = p_store_id;

            -- Set success message
            p_out_message := 'Store updated successfully';
            p_error := FALSE;

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

                p_out_message := SQLERRM;
        END;
    END IF;
END;
$$;
