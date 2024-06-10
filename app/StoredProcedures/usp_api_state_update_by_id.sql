DROP PROCEDURE IF EXISTS app.usp_api_state_update_by_id;
CREATE OR REPLACE PROCEDURE app.usp_api_state_update_by_id(
    IN p_state_id INTEGER,
    IN p_state_name VARCHAR,
    IN p_state_name_ascii VARCHAR,
    IN p_state_uf CHAR(2),
    IN p_longitude DOUBLE PRECISION,
    IN p_latitude DOUBLE PRECISION,
    IN p_modified_by INTEGER,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    stored_procedure_name VARCHAR := 'usp_api_state_update_by_id';
    error_message VARCHAR;
    warning_message VARCHAR;
    l_context TEXT;
BEGIN
    -- Trim the state name
    p_state_name := TRIM(p_state_name);
    p_state_name_ascii := unaccent(TRIM(p_state_name));
    p_state_uf := TRIM(p_state_uf);

    -- Check if the state exists
    IF NOT EXISTS (SELECT 1 FROM app.state WHERE state_id = p_state_id) THEN
        error_message := CONCAT(p_state_id, ' not found!');
        RAISE EXCEPTION USING MESSAGE = error_message, ERRCODE = '50005';
    END IF;

    -- Begin transaction
    BEGIN
        -- Update the state record
        UPDATE app.state
        SET state_name = p_state_name,
            state_name_ascii = p_state_name_ascii,
            state_uf = p_state_uf,
            longitude = p_longitude,
            latitude = p_latitude,
            modified_by = COALESCE(p_modified_by, modified_by),  -- Only update modified_by if provided
            modified_on = current_timestamp
        WHERE state_id = p_state_id;

        -- Notify successful update
        RAISE NOTICE '% updated successfully!', p_state_name;
    EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            -- Ensure the error_log table exists and is properly structured
            INSERT INTO app.error_log 
            (
                error_message, 
                error_code, 
                error_context
            )
            VALUES 
            (
                SQLERRM, 
                SQLSTATE, 
                l_context
            );
            -- Re-raise the exception to ensure the error is propagated
            RAISE;
    END;
END;
$$ LANGUAGE plpgsql;