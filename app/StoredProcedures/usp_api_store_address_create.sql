DROP PROCEDURE IF EXISTS app.usp_api_store_address_create;
CREATE OR REPLACE PROCEDURE app.usp_api_store_address_create(
    OUT p_out_store_address_id INTEGER,
    IN p_store_id INTEGER,
    IN p_number VARCHAR(50),
    IN p_street_id INTEGER,
    IN p_complement VARCHAR(100),
    IN p_longitude DOUBLE PRECISION,
    IN p_latitude DOUBLE PRECISION,
    IN p_created_by INTEGER,
    IN p_modified_by INTEGER,
    OUT p_error BOOLEAN
)
AS $$
DECLARE
    v_complement_ascii VARCHAR(100);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the complement to ASCII
        p_number := TRIM(p_number);
        p_complement := TRIM(p_complement);
        v_complement_ascii := unaccent(p_complement);

        -- Insert the new store address record
        INSERT INTO app.store_address 
        (
            store_id,
            street_id,
            number,
            complement,
            complement_ascii,
            longitude,
            latitude,
            created_by,
            created_on,
            modified_by,
            modified_on
        )
        VALUES 
        (
            p_store_id,
            p_street_id,
            p_number,
            p_complement,
            v_complement_ascii,
            p_longitude,
            p_latitude,
            p_created_by,
            CURRENT_TIMESTAMP,
            p_modified_by,
            CURRENT_TIMESTAMP
        )
        RETURNING store_address_id INTO p_out_store_address_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            
            -- Log the error
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
