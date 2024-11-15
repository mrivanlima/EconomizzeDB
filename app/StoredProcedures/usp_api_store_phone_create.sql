DROP PROCEDURE IF EXISTS app.usp_api_store_phone_create;
CREATE OR REPLACE PROCEDURE app.usp_api_store_phone_create(
    OUT p_store_phone_id INTEGER,
    IN p_store_id INT,
    IN p_country_code VARCHAR(5),
    IN p_state_code VARCHAR(5),
    IN p_phone_number VARCHAR(20),
    IN p_phone_national_format VARCHAR(30),
    IN p_phone_human_format VARCHAR(30),
    IN p_phone_164_format VARCHAR(20),
    IN p_is_main BOOLEAN,
    IN p_is_active BOOLEAN,
    IN p_is_whatsapp BOOLEAN,
    IN p_created_by INT,
    IN p_modified_by INT,
    OUT p_error BOOLEAN
)
AS $$
DECLARE
    l_context TEXT;
BEGIN

    p_country_code := TRIM(p_country_code);
    p_state_code := TRIM(p_state_code);
    p_phone_number := TRIM(p_phone_number);
    p_phone_national_format := TRIM(p_phone_national_format);
    p_phone_human_format := TRIM(p_phone_human_format);
    p_phone_164_format := TRIM(p_phone_164_format);
    -- Insert a new record into the store_phone table
    BEGIN
        INSERT INTO app.store_phone (
            store_id,
            country_code,
            state_code,
            phone_number,
            phone_national_format,
            phone_human_format,
            phone_164_format,
            is_main,
            is_active,
            is_whatsapp,
            created_by,
            created_on,
            modified_by,
            modified_on
        ) 
        VALUES (
            p_store_id,
            p_country_code,
            p_state_code,
            p_phone_number,
            p_phone_national_format,
            p_phone_human_format,
            p_phone_164_format,
            p_is_main,
            p_is_active,
            p_is_whatsapp,
            p_created_by,
            CURRENT_TIMESTAMP,
            p_modified_by,
            CURRENT_TIMESTAMP
        ) 
        RETURNING store_phone_id INTO p_store_phone_id;

        -- If the record is successfully inserted, set p_error to false
        p_error := FALSE;
        
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
$$ LANGUAGE plpgsql;
