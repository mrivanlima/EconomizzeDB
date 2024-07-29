DROP PROCEDURE IF EXISTS app.usp_api_user_login_update_by_uuid;
CREATE OR REPLACE PROCEDURE app.usp_api_user_login_update_by_uuid(
    IN p_user_unique_id uuid,
    OUT p_error_message VARCHAR(20),
    OUT p_error BOOLEAN
)
AS $$
DECLARE
    stored_procedure_name VARCHAR := 'usp_api_user_login_update_by_uuid';
    l_context TEXT;
BEGIN

    -- Check if uuid exists
    IF NOT EXISTS (SELECT 1 FROM app.User_login WHERE user_unique_id = p_user_unique_id) THEN
        p_error_message := CONCAT(p_user_unique_id, ' not found!');
        RETURN;
    END IF;

    -- Begin transaction
    BEGIN
        -- Update the state record
        UPDATE app.User_login
        SET is_verified = true,
            modified_by = COALESCE(p_modified_by, modified_by),  -- Only update modified_by if provided
            modified_on = current_timestamp
        WHERE user_unique_id = p_user_unique_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN

            ROLLBACK;
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