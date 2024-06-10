DROP PROCEDURE IF EXISTS app.usp_api_address_create;
CREATE OR REPLACE PROCEDURE app.usp_api_address_create(
    OUT p_out_address_id INTEGER,
    IN p_street_id INTEGER,
    IN p_complement VARCHAR(200),
    IN p_longitude DOUBLE PRECISION DEFAULT NULL,
    IN p_latitude DOUBLE PRECISION DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    v_complement_ascii VARCHAR(200);
    l_context TEXT;
BEGIN
    BEGIN
        -- Trim and convert the complement to ASCII
        p_complement := TRIM(p_complement);
        v_complement_ascii := unaccent(p_complement);

        -- Insert the new address record
        INSERT INTO app.address 
        (
            street_id,
            complement,
            complement_ascii,
            longitude,
            latitude,
            created_by,
            modified_by
        )
        VALUES 
        (
            p_street_id,
            p_complement,
            v_complement_ascii,
            p_longitude,
            p_latitude,
            p_created_by,
            p_modified_by
        ) RETURNING address_id INTO p_out_address_id;

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