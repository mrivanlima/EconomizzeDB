DROP PROCEDURE IF EXISTS app.usp_api_user_address_create;
CREATE OR REPLACE PROCEDURE app.usp_api_user_address_create(
    IN p_user_id INTEGER,
    IN p_address_id INTEGER,
    IN p_address_type_id SMALLINT,
    IN p_main_address	BOOLEAN DEFAULT false, 
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
BEGIN
    BEGIN
        -- Insert the new user address record
        INSERT INTO app.user_address 
        (
            user_id,
            address_id,
            address_type_id,
            main_address,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_user_id,
            p_address_id,
            p_address_type_id,
            p_main_address,
            p_created_by,
            p_modified_by
        );

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