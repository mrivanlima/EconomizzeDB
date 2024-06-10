DROP PROCEDURE IF EXISTS app.usp_api_address_type_create;
CREATE OR REPLACE PROCEDURE app.usp_api_address_type_create(
    OUT p_out_address_type_id INTEGER,
    IN p_address_type_name VARCHAR(20),
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    v_address_type_name_ascii VARCHAR(20);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the address type name to ASCII
        p_address_type_name := TRIM(p_address_type_name);
        v_address_type_name_ascii := unaccent(p_address_type_name);

        -- Insert the new address type record
        INSERT INTO app.address_type 
        (
            address_type_name,
            address_type_name_ascii,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_address_type_name,
            v_address_type_name_ascii,
            p_created_by,
            p_modified_by
        ) RETURNING address_type_id INTO p_out_address_type_id;

        EXCEPTION
            WHEN OTHERS THEN
                p_error := TRUE;
                GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
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
